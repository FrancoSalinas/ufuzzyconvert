require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class SugenoVariableTest < Test::Unit::TestCase

  def setup

    @system_data = {}
    @output_data = {
      :index => 1,
      :parameters => {
        :Range => [-100, 100]
      },
      :membership => {
        1 => Hash.new,
        2 => Hash.new
      }
    }
  end

  def test_from_fis_range_swapped
    @output_data[:parameters][:Range] = [30, 20]

    assert_raise(
      UFuzzyConvert::InputError.new "Range bounds are swapped."
    ) do
      UFuzzyConvert::SugenoVariable.from_fis_data(@output_data, @system_data)
    end
  end

  def test_load_rules_from_fis_data
    options = {}

    output = UFuzzyConvert::SugenoVariable.from_fis_data(
      @output_data, @system_data
    )

    rules_data = [
      mock('rule_data_1'), mock('rule_data_2')
    ]

    rule_mock_1 = mock('rule_1')
    rule_mock_1
      .expects(:to_cfs)
      .returns(['R'])

    rule_mock_1
      .expects(:to_cfs)
      .returns(['R'])

    rule_mock_2 = mock('rule_2')
    rule_mock_2
      .expects(:to_cfs)
      .returns(['U'])

    UFuzzyConvert::SugenoRule
      .stubs(:from_fis_data)
      .returns(rule_mock_1)
      .then
      .returns(rule_mock_2)

    output.load_rules_from_fis_data(
      mock('inputs'),
      UFuzzyConvert::TNormMinimum.new,
      UFuzzyConvert::SNormMaximum.new,
      rules_data
    )

    membership_function_mock = mock('membership')
    membership_function_mock
      .expects(:variable)
      .returns(output)
    membership_function_mock
      .expects(:to_cfs)
      .returns(['M', 'F'])
    membership_function_mock
      .expects(:class)
      .returns(UFuzzyConvert::MembershipFunction::Linear)
      .at_least_once

    output.membership_functions = [membership_function_mock]

    cfs = output.to_cfs(options = options)

    assert_equal(
      [1, 2, 'R', 'U'], cfs
    )

    UFuzzyConvert::SugenoRule.unstub(:from_fis_data)
  end
end
