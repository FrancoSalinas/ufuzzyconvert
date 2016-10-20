require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/output_variable'
include Mocha::API


class OutputVariableTest < Test::Unit::TestCase

  def setup
    @fis_data = Hash.new

    @fis_data[:system] = Hash.new
    @fis_data[:system][:Type] = 'mamdani'
  end

  def test_from_fis_missing_system
    @fis_data.delete :system

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "System section not defined."
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_missing_type
    @fis_data[:system].delete :Type

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Inference type not defined."
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_unsupported_type
    @fis_data[:system][:Type] = "asd"

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Inference type asd not supported."
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_mamdani_input_exception
    @fis_data[:system][:Type] = "mamdani"

    UFuzzyConvert::OutputVariable::Mamdani
      .expects(:from_fis_data)
      .with(@fis_data, 1)
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Output 1: msg"
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    end

      UFuzzyConvert::OutputVariable::Mamdani.unstub(:from_fis_data)
  end

  def test_from_fis_sugeno_feature_exception
    @fis_data[:system][:Type] = "sugeno"

    UFuzzyConvert::OutputVariable::Sugeno
      .expects(:from_fis_data)
      .with(@fis_data, 1)
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Output 1: msg"
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    end

    UFuzzyConvert::OutputVariable::Sugeno.unstub(:from_fis_data)
  end

  def test_success
    @fis_data[:system][:Type] = "mamdani"

    UFuzzyConvert::OutputVariable::Mamdani
      .expects(:from_fis_data)
      .with(@fis_data, 1)
      .returns([0x00, 0x01, 0x02, 0x03])
      .once

    assert_equal(
      [0x00, 0x01, 0x02, 0x03],
      UFuzzyConvert::OutputVariable.from_fis_data(@fis_data, 1)
    )

    UFuzzyConvert::OutputVariable::Mamdani.unstub(:from_fis_data)
  end

end
