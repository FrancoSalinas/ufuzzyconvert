require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/input_variable'
include Mocha::API


class InputVariableTest < Test::Unit::TestCase

  def setup
    @input_data = Hash.new

    @input_data[:index] = 1
    @input_data[:membership] = {
      1 => Hash.new,
      2 => Hash.new
    }
    @input_data[:parameters] = Hash.new
    @input_data[:parameters][:Range] = [-100, 100]
  end

  def teardown
    UFuzzyConvert::MembershipFunction.unstub(:from_fis_data)
  end

  def test_from_fis_missing_parameters
    @input_data.delete :parameters

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: No parameters found. Range is required."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_from_fis_missing_range
    @input_data[:parameters].delete :Range

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range not defined."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_from_fis_invalid_range_parameter
    @input_data[:parameters][:Range] = [10, 20, 30]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range matrix must have two elements."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_from_fis_invalid_range_type
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(4)

    @input_data[:parameters][:Range] = ["asd", 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range lower bound must be a number."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end

    @input_data[:parameters][:Range] = [10, "asd"]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range upper bound must be a number."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_from_fis_range_swapped
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(mock)
      .times(2)

    @input_data[:parameters][:Range] = [30, 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range bounds are swapped."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_from_fis_membership_exception
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .with(@input_data[:membership][1])
      .returns(mock)
      .once

    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .with(@input_data[:membership][2])
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: msg"
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_success

    options = {:tsize => 8, :dsteps => 8}

    membership_function_mock = mock('membership_function')
    membership_function_mock
      .expects(:to_cfs)
      .with(
        @input_data[:parameters][:Range][0],
        @input_data[:parameters][:Range][1],
        options)
      .returns(['M', 'F'])
      .times(2)
    UFuzzyConvert::MembershipFunction
      .expects(:from_fis_data)
      .returns(membership_function_mock)
      .times(2)

    input_variable = UFuzzyConvert::InputVariable.from_fis_data(@input_data)

    cfs = input_variable.to_cfs(options = options)

    assert_equal cfs, [2, 0, 'M', 'F', 'M', 'F']

  end
end
