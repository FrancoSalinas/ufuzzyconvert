require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/bell_shaped'
include Mocha::API


class BellShapedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      3, UFuzzyConvert::MembershipFunction::BellShaped::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::BellShaped.new(
        @variable_mock, "1", 2, 3
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::BellShaped.new(
        @variable_mock, 1, "2", 3
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::BellShaped.new(
        @variable_mock, 1, 2, "3"
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "a cannot be 0."
    ) do
      UFuzzyConvert::MembershipFunction::BellShaped.new(
        @variable_mock, 0, 2, 3
      )
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::BellShaped.new(
      @variable_mock, 2, 4, 6
    )

    assert_in_delta(1.5239e-04, function.evaluate(0), 1.5239e-04 * 1e-4)
    assert_in_delta(3.8911e-03, function.evaluate(2), 3.8911e-03 * 1e-4)
    assert_in_delta(5.0000e-01, function.evaluate(4), 5.0000e-01 * 1e-4)
    assert_in_delta(1.0000e+00, function.evaluate(6), 1.0000e+00 * 1e-4)
    assert_in_delta(5.0000e-01, function.evaluate(8), 5.0000e-01 * 1e-4)
    assert_in_delta(3.8911e-03, function.evaluate(10), 3.8911e-03 * 1e-4)
  end

end
