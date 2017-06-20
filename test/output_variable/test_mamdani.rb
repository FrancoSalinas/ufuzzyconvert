require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class MamdaniVariableTest < Test::Unit::TestCase

  def setup

    @system_data = {
      :AggMethod => 'max',
      :DefuzzMethod => 'centroid',
      :ImpMethod => 'min'
    }
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

  def test_from_fis_activation_exception

    UFuzzyConvert::TNorm
      .expects(:from_fis)
      .with(@system_data[:ImpMethod])
      .raises(UFuzzyConvert::InputError, "msg")

    assert_raise(
      UFuzzyConvert::InputError.new "Output 1: msg"
    ) do
      UFuzzyConvert::MamdaniVariable.from_fis_data(@output_data, @system_data)
    end

    UFuzzyConvert::TNorm.unstub(:from_fis)
  end

  def test_from_fis_aggregation_exception

    UFuzzyConvert::SNorm
      .expects(:from_fis)
      .with(@system_data[:AggMethod])
      .raises(UFuzzyConvert::InputError, "msg")

    assert_raise(
      UFuzzyConvert::InputError.new "Output 1: msg"
    ) do
      UFuzzyConvert::MamdaniVariable.from_fis_data(@output_data, @system_data)
    end

    UFuzzyConvert::SNorm.unstub(:from_fis)
  end

  def test_from_fis_defuzzifier_exception

    UFuzzyConvert::Defuzzifier
      .expects(:from_fis)
      .with(@system_data[:DefuzzMethod])
      .raises(UFuzzyConvert::InputError, "msg")

    assert_raise(
      UFuzzyConvert::InputError.new "Output 1: msg"
    ) do
      UFuzzyConvert::MamdaniVariable.from_fis_data(@output_data, @system_data)
    end

    UFuzzyConvert::Defuzzifier.unstub(:from_fis)
  end

  def test_from_fis_invalid_lower_range_type
    @output_data[:parameters][:Range] = ["asd", 20]

    assert_raise(
      UFuzzyConvert::InputError.new "Range lower bound must be a number."
    ) do
      UFuzzyConvert::MamdaniVariable.from_fis_data(@output_data, @system_data)
    end
  end

  def test_to_cfs_missing_dsteps_option
    output_variable = UFuzzyConvert::MamdaniVariable.from_fis_data(
      @output_data, @system_data
    )

    options = {:tsize => 8}
    assert_raise(
      UFuzzyConvert::InputError.new "Defuzzification steps not defined."
    ) do
      output_variable.to_cfs(options = options)
    end
  end

  def test_to_cfs_dsteps_too_big
    output_variable = UFuzzyConvert::MamdaniVariable.from_fis_data(
      @output_data, @system_data
    )

    assert_raise(
      UFuzzyConvert::InputError.new "options[:dsteps] must be less or equal to 14."
    ) do
      output_variable.to_cfs({:dsteps => 15})
    end
  end

  def test_load_rules_from_fis_data
    options = {:tsize => 8, :dsteps => 8}

    output = UFuzzyConvert::MamdaniVariable.from_fis_data(
      @output_data, @system_data
    )

    rules_data = [
      mock('rule_data_1'), mock('rule_data_2')
    ]

    rule_mock_1 = mock('rule_1')
    rule_mock_1
      .expects(:to_cfs)
      .returns(['R'])

    rule_mock_2 = mock('rule_2')
    rule_mock_2
      .expects(:to_cfs)
      .returns(['U'])

    UFuzzyConvert::MamdaniRule
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

    output.membership_functions = [membership_function_mock]

    cfs = output.to_cfs(options = options)

    assert_equal(
      [0, 1, 'M', 'F', 0, 0, 0, 8, 0, 2, 'R', 'U'], cfs
    )

    UFuzzyConvert::MamdaniRule.unstub(:from_fis_data)
  end
end
