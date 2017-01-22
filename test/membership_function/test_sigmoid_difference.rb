require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/sigmoid_difference'
include Mocha::API


class SigmoidDifferenceTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      4, UFuzzyConvert::MembershipFunction::SigmoidDifference::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidDifference.new(
        @variable_mock, "1", 2, 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidDifference.new(
        @variable_mock, 1, "2", 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidDifference.new(
        @variable_mock, 1, 2, "3", 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidDifference.new(
        @variable_mock, 1, 2, 3, "4"
      )
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::SigmoidDifference.new(
      @variable_mock, 5, 2, 5, 7
    )

    assert_in_delta(4.5398e-05, function.evaluate(0), 4.5398e-05 * 1e-4)
    assert_in_delta(5.0000e-01, function.evaluate(2), 5.0000e-01 * 1e-4)
    assert_in_delta(9.9995e-01, function.evaluate(4), 9.9995e-01 * 1e-4)
    assert_in_delta(9.9331e-01, function.evaluate(6), 9.9331e-01 * 1e-4)
    assert_in_delta(6.6929e-03, function.evaluate(8), 6.6929e-03 * 1e-4)
    assert_in_delta(3.0590e-07, function.evaluate(10), 3.0590e-07 * 1e-4)
  end

end
