require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class FuzzySystemTest < Test::Unit::TestCase


  def teardown
    Parser.unstub(:parse)
    UFuzzyConvert::TNorm.unstub(:from_fis)
    UFuzzyConvert::SNorm.unstub(:from_fis)
    UFuzzyConvert::InputVariable.unstub(:from_fis_data)
    UFuzzyConvert::OutputVariable.unstub(:from_fis_data)
  end

  def test_from_fis_io_error
    Parser.expects(:parse).with("fis_str").raises(Exception, "msg").once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end
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
    UFuzzyConvert::InputVariable
      .expects(:from_fis_data)
      .with(fis_data, 1)
      .returns(mock)
      .once

    UFuzzyConvert::InputVariable
      .expects(:from_fis_data)
      .with(fis_data, 2)
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end
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

    Parser.expects(:parse).with("fis_str").returns(fis_data).once
    UFuzzyConvert::OutputVariable
      .expects(:from_fis_data)
      .with(fis_data, 1)
      .returns(mock)
      .once

    UFuzzyConvert::OutputVariable
      .expects(:from_fis_data)
      .with(fis_data, 2)
      .returns(mock)
      .once

    UFuzzyConvert::OutputVariable
      .expects(:from_fis_data)
      .with(fis_data, 3)
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "msg"
    ) do
      UFuzzyConvert::FuzzySystem.from_fis("fis_str")
    end
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

    Parser.expects(:parse).with("fis_str").returns(fis_data).once

    t_norm_mock = mock('tnorm')
    t_norm_mock
      .expects(:to_cfs)
      .with()
      .returns(0)
      .once
    UFuzzyConvert::TNorm
      .expects(:from_fis)
      .with("min")
      .returns(t_norm_mock)
      .once

    s_norm_mock = mock('snorm')
    s_norm_mock
      .expects(:to_cfs)
      .with()
      .returns(1).
      once
    UFuzzyConvert::SNorm
      .expects(:from_fis)
      .with("sum")
      .returns(s_norm_mock)
      .once

    input_variable_mock = mock('input')
    input_variable_mock
      .expects(:to_cfs)
      .with(options)
      .returns(['I', 'N'])
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

  end
end
