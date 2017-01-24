require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class FuzzySystemTest < Test::Unit::TestCase


  def test_from_fis_io_error
    Parser.expects(:parse).with("fis_str").raises(Exception, "msg").once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
  end

  def test_from_fis_missing_system
    fis_data = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "System section not defined."
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
  end

  def test_from_fis_missing_and_method
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:OrMethod] = "max"

    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "AndMethod not defined."
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
  end

  def test_from_fis_missing_or_method
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"

    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "OrMethod not defined."
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
  end

  def test_from_fis_tnorm_exception
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "max"

    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    UFuzzyConvert::TNorm
      .expects(:from_fis)
      .with("min")
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
    UFuzzyConvert::TNorm.unstub(:from_fis)
  end

  def test_from_fis_snorm_exception
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "max"

    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    UFuzzyConvert::SNorm
      .expects(:from_fis)
      .with("max")
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
    UFuzzyConvert::SNorm.unstub(:from_fis)
  end

  def test_from_fis_invalid_input
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "max"

    fis_data[:inputs] = Hash.new
    fis_data[:inputs][1] = Hash.new
    fis_data[:inputs][2] = Hash.new
    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    input_mock = mock('input')
    input_mock
      .expects(:load_membership_functions_from_fis_data)

    UFuzzyConvert::InputVariable
      .stubs(:from_fis_data)
      .returns(input_mock)
      .then
      .raises(UFuzzyConvert::FeatureError, "msg")

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
    UFuzzyConvert::InputVariable.unstub(:from_fis_data)
  end

  def test_from_fis_invalid_output
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "max"

    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new
    fis_data[:outputs][2] = Hash.new
    fis_data[:outputs][3] = Hash.new

    fis_data[:rules] = [mock]

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    output_mock = mock('output')
    output_mock
      .expects(:load_membership_functions_from_fis_data)
      .twice

    output_mock
      .expects(:load_rules_from_fis_data)
      .twice

    UFuzzyConvert::OutputVariable
      .stubs(:from_fis_data)
      .returns(output_mock)
      .twice
      .then
      .raises(UFuzzyConvert::FeatureError, "msg")

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
    UFuzzyConvert::OutputVariable.unstub(:from_fis_data)
  end

  def test_from_fis_no_outputs
    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "max"

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "At least one output variable is required."
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end

    Parser.unstub(:parse)
  end

  def test_success

    options = {:tsize => 8, :dsteps => 8}

    fis_data = Hash.new

    fis_data[:system] = Hash.new
    fis_data[:system][:AndMethod] = "min"
    fis_data[:system][:OrMethod] = "sum"

    fis_data[:inputs] = Hash.new
    fis_data[:inputs][1] = Hash.new
    fis_data[:inputs][2] = Hash.new
    fis_data[:inputs][3] = Hash.new
    fis_data[:outputs] = Hash.new
    fis_data[:outputs][1] = Hash.new
    fis_data[:outputs][2] = Hash.new

    fis_data[:rules] = []

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    input_variable_mock = mock('input')
    input_variable_mock
      .expects(:to_cfs)
      .with(options)
      .returns(['I', 'N'])
      .times(3)
    input_variable_mock
      .expects(:load_membership_functions_from_fis_data)
      .times(3)
    UFuzzyConvert::InputVariable
      .expects(:from_fis_data)
      .returns(input_variable_mock)
      .times(3)

    output_variable_mock = mock('output')
    output_variable_mock
      .expects(:to_cfs)
      .with(options)
      .returns(['O', 'U', 'T'])
      .times(2)
    output_variable_mock
      .expects(:load_membership_functions_from_fis_data)
      .times(2)
    output_variable_mock
      .expects(:load_rules_from_fis_data)
      .times(2)
    UFuzzyConvert::OutputVariable
      .expects(:from_fis_data)
      .returns(output_variable_mock)
      .times(2)

    fuzzy_system = UFuzzyConvert::FuzzySystem.from_fis("fis_str")

    cfs = fuzzy_system.to_cfs(options = options)

    assert_equal cfs, [
      'C', 'F', 'S', 0, 0, 1, 3, 2,
      'I', 'N',
      'I', 'N',
      'I', 'N',
      'O', 'U', 'T',
      'O', 'U', 'T'
    ]

    Parser.unstub(:parse)
    UFuzzyConvert::InputVariable.unstub(:from_fis_data)
    UFuzzyConvert::OutputVariable.unstub(:from_fis_data)
  end
end
