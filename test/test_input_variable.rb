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
    @input_data[:parameters] = Hash.new
    @input_data[:parameters][:Range] = [-100, 100]
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
    @input_data[:parameters][:Range] = [30, 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Input 1: Range bounds are swapped."
    ) do
      UFuzzyConvert::InputVariable.from_fis_data(@input_data)
    end
  end

  def test_success

    options = {:tsize => 8, :dsteps => 8}

    input_variable = UFuzzyConvert::InputVariable.from_fis_data(@input_data)

    membership_function_mock_1 = mock('membership_function_1')
    membership_function_mock_1
      .expects(:variable)
      .with()
      .returns(input_variable)
    membership_function_mock_1
      .expects(:to_cfs)
      .with(-100, 100, options)
      .returns(['M'])

    membership_function_mock_2 = mock('membership_function_2')
    membership_function_mock_2
      .expects(:variable)
      .with()
      .returns(input_variable)
    membership_function_mock_2
      .expects(:to_cfs)
      .with(-100, 100, options)
      .returns(['F'])

    input_variable.membership_functions = [
      membership_function_mock_1,
      membership_function_mock_2
    ]

    cfs = input_variable.to_cfs(options = options)

    assert_equal cfs, [2, 0, 'M', 'F']

  end

  def test_integration_with_membership_function
    options = {:tsize => 2, :dsteps => 8}

    input_variable = UFuzzyConvert::InputVariable.from_fis_data(@input_data)

    @input_data[:membership] = {
        1 => {
          :index => 1,
          :name => "mf name",
          :type => "rectmf",
          :parameters => [0, 100]
        },
        2 => {
          :index => 2,
          :name => "mf other name",
          :type => "smf",
          :parameters => [-50, 50]
        }
    }

    input_variable.load_membership_functions_from_fis_data(@input_data)

    cfs = input_variable.to_cfs(options = options)

    assert_equal [
      0x02, 0x00,
        # Non-tabulated, reserved.
        0x00, 0x00,
          0x20, 0x00,
          0x20, 0x00,
          0x40, 0x00,
          0x40, 0x00,
        # Tabulated, table index size.
        0x01, 0x02,
          0x00, 0x00,
          0x08, 0x00,
          0x38, 0x00,
          0x40, 0x00
    ], cfs

    assert_equal 1, input_variable.membership_functions[0].index
    assert_equal 2, input_variable.membership_functions[1].index
  end
end
