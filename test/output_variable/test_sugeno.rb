require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class SugenoTest < Test::Unit::TestCase

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
  end

  def test_from_fis_missing_outputs_section
    @fis_data.delete :outputs

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Outputs section not defined."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_missing_output_data
    @fis_data[:outputs].delete 1

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Index not found."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_missing_range
    @fis_data[:outputs][1][:parameters].delete :Range

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range not defined."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_invalid_range_parameter
    @fis_data[:outputs][1][:parameters][:Range] = [10, 20, 30]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range matrix must have two elements."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_invalid_lower_range_type

    @fis_data[:outputs][1][:parameters][:Range] = ["asd", 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range lower bound must be a number."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_invalid_upper_range_type

    @fis_data[:outputs][1][:parameters][:Range] = [10, "asd"]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range upper bound must be a number."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_from_fis_range_swapped

    @fis_data[:outputs][1][:parameters][:Range] = [30, 20]
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range bounds are swapped."
    ) do
      UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(@fis_data, 1)
    end
  end

  def test_success
    options = {:tsize => 8, :dsteps => 8}

    output_variable = UFuzzyConvert::OutputVariable::Sugeno.from_fis_data(
      @fis_data, 1
    )

    rule_mock_1 = mock('rule')
    rule_mock_1
      .expects(:to_cfs)
      .with(-100, 100)
      .returns(['R'])
      .once

    rule_mock_2 = mock('rule')
    rule_mock_2
      .expects(:to_cfs)
      .with(-100, 100)
      .returns(['U'])
      .once

    output_variable.rules = [rule_mock_1, rule_mock_2]

    cfs = output_variable.to_cfs(options = options)

    assert_equal [1, 2, 'R', 'U'], cfs
  end
end
