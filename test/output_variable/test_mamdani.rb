require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class MamdaniTest < Test::Unit::TestCase

  def setup
    @fis_data = Hash.new

    @fis_data[:system] = Hash.new
    @fis_data[:outputs] = {
      1 => {
        :parameters => {
          :Range => [-100, 100]
        },
        :membership => {
          1 => Hash.new,
          2 => Hash.new
        }
      },
      2 => {
        :parameters => {
          :Range => [-100, 100]
        },
        :membership => {
          1 => Hash.new,
          2 => Hash.new
        }
      }
    }
    @fis_data[:rules] = [Hash.new, Hash.new]

    t_norm_mock = mock('t_norm_mock')
    t_norm_mock
      .expects(:to_cfs)
      .with()
      .returns(['T'])
      .once
    UFuzzyConvert::FuzzySystem
      .expects(:activation_operator_from_fis_data)
      .returns(t_norm_mock)
      .once

    s_norm_mock = mock('s_norm_mock')
    s_norm_mock
      .expects(:to_cfs)
      .with()
      .returns(['S'])
      .once
    UFuzzyConvert::FuzzySystem
      .expects(:aggregation_operator_from_fis_data)
      .returns(s_norm_mock)
      .once

    defuzzifier_mock = mock('defuzzifier_mock')
    defuzzifier_mock
      .expects(:to_cfs)
      .with()
      .returns(['D'])
      .once
    UFuzzyConvert::FuzzySystem
      .expects(:defuzzifier_from_fis_data)
      .returns(defuzzifier_mock)
      .once
  end

  def teardown
    UFuzzyConvert::FuzzySystem.unstub(:defuzzifier_from_fis_data)
    UFuzzyConvert::FuzzySystem.unstub(:aggregation_operator_from_fis_data)
    UFuzzyConvert::FuzzySystem.unstub(:activation_operator_from_fis_data)
  end

  def test_from_fis_missing_outputs_section
    @fis_data.delete :outputs

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Outputs section not defined."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_missing_system_section
    @fis_data.delete :system

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "System section not defined."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_missing_output_data
    @fis_data[:outputs].delete 1

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Index not found."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_activation_exception
    UFuzzyConvert::FuzzySystem.unstub(:activation_operator_from_fis_data)
    UFuzzyConvert::FuzzySystem
      .expects(:activation_operator_from_fis_data)
      .with(@fis_data[:system])
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "msg"
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_aggregation_exception
    UFuzzyConvert::FuzzySystem
      .expects(:aggregation_operator_from_fis_data)
      .once
    UFuzzyConvert::FuzzySystem
      .expects(:aggregation_operator_from_fis_data)
      .with(@fis_data[:system])
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "msg"
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_defuzzifier_exception
    UFuzzyConvert::FuzzySystem
      .expects(:defuzzifier_from_fis_data)
      .once
    UFuzzyConvert::FuzzySystem
      .expects(:defuzzifier_from_fis_data)
      .with(@fis_data[:system])
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "msg"
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end

  end

  def test_from_fis_missing_range
    @fis_data[:outputs][1][:parameters].delete :Range

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range not defined."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_invalid_range_parameter
    @fis_data[:outputs][1][:parameters][:Range] = [10, 20, 30]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range matrix must have two elements."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_invalid_lower_range_type
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(2)

    @fis_data[:outputs][1][:parameters][:Range] = ["asd", 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range lower bound must be a number."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end

    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end

  def test_from_fis_invalid_upper_range_type
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(2)

    @fis_data[:outputs][1][:parameters][:Range] = [10, "asd"]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range upper bound must be a number."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end

    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end

  def test_from_fis_range_swapped
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(2)

    @fis_data[:outputs][1][:parameters][:Range] = [30, 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range bounds are swapped."
    ) do
      UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(@fis_data, 1)
    end

    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end

  def test_to_cfs_missing_dsteps_option
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(2)

    output_variable = UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(
      @fis_data, 1
    )

    options = {:tsize => 8}
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Defuzzification steps not defined."
    ) do
      output_variable.to_cfs(options = options)
    end

    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end

  def test_success
    options = {:tsize => 8, :dsteps => 8}

    membership_function_mock = mock('membership_function')
    membership_function_mock
      .expects(:to_cfs)
      .with(
        @fis_data[:outputs][1][:parameters][:Range][0],
        @fis_data[:outputs][1][:parameters][:Range][1],
        options)
      .returns(['M', 'F'])
      .times(2)
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(membership_function_mock)
      .times(2)

    output_variable = UFuzzyConvert::OutputVariable::Mamdani.from_fis_data(
      @fis_data, 1
    )

    rule_mock_1 = mock('rule')
    rule_mock_1
      .expects(:to_cfs)
      .with()
      .returns(['R'])
      .once
    rule_mock_2 = mock('rule')
    rule_mock_2
      .expects(:to_cfs)
      .with()
      .returns(['U'])
      .once

    output_variable.rules = [rule_mock_1, rule_mock_2]

    cfs = output_variable.to_cfs(options = options)

    assert_equal(
      [0, 2, 'M', 'F', 'M', 'F', 'T', 'S', 'D', 8, 0, 2, 'R', 'U'], cfs
    )

    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end
end
