require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/fuzzy_system'
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

  def test_suggested_range_with_one_rule
    variable = UFuzzyConvert::SugenoVariable.new 0, 100

    rules_data = [mock]

    rule_mock_1 = mock('rule_1')
    rule_mock_1
      .expects(:output_limits)
      .returns([-32768, 32767])
    rule_mock_1
      .expects(:coefficient_overflow)
      .returns(0.5)
    rule_mock_1
      .expects(:fit_independent_term)
      .returns([0, 16384])

    UFuzzyConvert::SugenoRule
      .stubs(:from_fis_data)
      .returns(rule_mock_1)

    variable.load_rules_from_fis_data(
      mock('inputs'),
      UFuzzyConvert::TNormMinimum.new,
      UFuzzyConvert::SNormMaximum.new,
      rules_data
    )

    range_low, range_high = variable.suggested_range

    upper_bound = 32767.to_cfs(range_low, range_high)
    assert_equal 0x7F, upper_bound[0]
    assert 0xFD < upper_bound[1]

    lower_bound = -32768.to_cfs(range_low, range_high)
    assert_equal 0x80, lower_bound[0]
    assert 0x02 > lower_bound[1]

    UFuzzyConvert::SugenoRule.unstub(:from_fis_data)
  end

  def test_suggested_range_with_many_rules
    variable = UFuzzyConvert::SugenoVariable.new 0, 100

    rules_data = [mock, mock, mock]

    rule_mock_1 = mock('rule_1')
    rule_mock_1
      .expects(:output_limits)
      .returns([-200, 199])
    rule_mock_1
      .expects(:coefficient_overflow)
      .returns(0.5)
    rule_mock_1
      .expects(:fit_independent_term)
      .returns([48.00384527351798, 174.00576791027697])

    rule_mock_2 = mock('rule_2')
    rule_mock_2
      .expects(:output_limits)
      .returns([100, 300])
    rule_mock_2
      .expects(:coefficient_overflow)
      .returns(-1.0)
    rule_mock_2
      .expects(:fit_independent_term)
      .returns([48.00384527351798, 174.00576791027697])

    rule_mock_3 = mock('rule_3')
    rule_mock_3
      .expects(:output_limits)
      .returns([-204, 0])
    rule_mock_3
      .expects(:coefficient_overflow)
      .returns(-1.0)
    rule_mock_3
      .expects(:fit_independent_term)
      .returns([48.00384527351798, 174.00576791027697])

    UFuzzyConvert::SugenoRule
      .stubs(:from_fis_data)
      .returns(rule_mock_1)
      .then
      .returns(rule_mock_2)
      .then
      .returns(rule_mock_3)

    variable.load_rules_from_fis_data(
      mock('inputs'),
      UFuzzyConvert::TNormMinimum.new,
      UFuzzyConvert::SNormMaximum.new,
      rules_data
    )

    range_low, range_high = variable.suggested_range

    upper_bound = 300.to_cfs(range_low, range_high)
    assert_equal 0x7F, upper_bound[0]
    assert 0xFD < upper_bound[1]

    lower_bound = -204.to_cfs(range_low, range_high)
    assert_equal 0x80, lower_bound[0]
    assert 0x02 > lower_bound[1]

    UFuzzyConvert::SugenoRule.unstub(:from_fis_data)
  end

  def test_suggested_range_with_small_overflow
    variable = UFuzzyConvert::SugenoVariable.new 0, 100

    rules_data = [mock]

    rule_mock_1 = mock('rules')
    rule_mock_1
      .expects(:output_limits)
      .returns([-32768, 32767])
    rule_mock_1
      .expects(:coefficient_overflow)
      .returns(0.5)
    rule_mock_1
      .expects(:fit_independent_term)
      .returns([0, 16384])

    UFuzzyConvert::SugenoRule
      .stubs(:from_fis_data)
      .returns(rule_mock_1)

    variable.load_rules_from_fis_data(
      mock('inputs'),
      UFuzzyConvert::TNormMinimum.new,
      UFuzzyConvert::SNormMaximum.new,
      rules_data
    )

    range_low, range_high = variable.suggested_range

    assert_equal [0x7F, 0xFF], 32767.01.to_cfs(range_low, range_high)
    assert_equal [0x80, 0x00], -32768.01.to_cfs(range_low, range_high)

    UFuzzyConvert::SugenoRule.unstub(:from_fis_data)
  end
end
