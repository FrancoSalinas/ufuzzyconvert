require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/pi_shaped'
include Mocha::API


class PiShapedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
    @variable_mock.expects(:is_a?)
      .with(UFuzzyConvert::Variable)
      .returns(true)
      .at_least_once
  end

  def test_parameter_number

    assert_equal(
      4, UFuzzyConvert::MembershipFunction::PiShaped::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new(
        @variable_mock, "1", 2, 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new(
        @variable_mock, 1, "2", 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new(
        @variable_mock, 1, 2, "3", 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new(
        @variable_mock, 1, 2, 3, "4"
      )
    end
  end

  def test_parameters_not_ordered
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new @variable_mock, 2, 1, 3, 4
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new @variable_mock, 1, 3, 2, 4
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::PiShaped.new @variable_mock, 1, 2, 4, 3
    end

  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::PiShaped.new(
      @variable_mock, 1, 4, 5, 10
    )

    assert_in_delta(0.00000, function.evaluate(0), 0.00000 * 1e-4)
    assert_in_delta(0.22222, function.evaluate(2), 0.22222 * 1e-4)
    assert_in_delta(0.77778, function.evaluate(3), 0.77778 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(4), 1.00000 * 1e-4)
    assert_in_delta(0.92000, function.evaluate(6), 0.92000 * 1e-4)
    assert_in_delta(0.32000, function.evaluate(8), 0.32000 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(10), 0.00000 * 1e-4)
  end

end
