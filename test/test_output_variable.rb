require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class OutputVariableTest < Test::Unit::TestCase

  def setup
    @system_data = {
      :Type => 'mamdani'
    }

    @output_data = {
      :index => 1
    }
  end

  def test_from_fis_missing_type
    @system_data.delete :Type

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Inference type not defined."
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@output_data, @system_data)
    end
  end

  def test_from_fis_unsupported_type
    @system_data[:Type] = "asd"

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Inference type asd not supported."
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@output_data, @system_data)
    end
  end

  def test_from_fis_mamdani_input_exception
    @system_data[:Type] = "mamdani"

    UFuzzyConvert::MamdaniVariable
      .expects(:from_fis_data)
      .with(@output_data, @system_data)
      .raises(UFuzzyConvert::InputError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Output 1: msg"
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@output_data, @system_data)
    end

    UFuzzyConvert::MamdaniVariable.unstub(:from_fis_data)
  end

  def test_from_fis_sugeno_feature_exception
    @system_data[:Type] = "sugeno"

    UFuzzyConvert::SugenoVariable
      .expects(:from_fis_data)
      .with(@output_data, @system_data)
      .raises(UFuzzyConvert::FeatureError, "msg")
      .once

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Output 1: msg"
    ) do
      UFuzzyConvert::OutputVariable.from_fis_data(@output_data, @system_data)
    end

    UFuzzyConvert::SugenoVariable.unstub(:from_fis_data)
  end

  def test_success
    @system_data[:Type] = "mamdani"

    UFuzzyConvert::MamdaniVariable
      .expects(:from_fis_data)
      .with(@output_data, @system_data)
      .returns([0x00, 0x01, 0x02, 0x03])
      .once

    assert_equal(
      [0x00, 0x01, 0x02, 0x03],
      UFuzzyConvert::OutputVariable.from_fis_data(@output_data, @system_data)
    )

    UFuzzyConvert::MamdaniVariable.unstub(:from_fis_data)
  end

end
