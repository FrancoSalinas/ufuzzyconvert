require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/z_shaped'
include Mocha::API


class ZShapedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      2, UFuzzyConvert::MembershipFunction::ZShaped::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new @variable_mock, "1", 2
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new @variable_mock, 1, "2"
    end

  end

  def test_parameters_not_ordered
    assert_raise(
      UFuzzyConvert::InputError.new "a must be lower than b."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new @variable_mock, 2, 1
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::ZShaped.new(
      @variable_mock, 3, 7
    )

    assert_in_delta(1.00000, function.evaluate(0), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(2), 1.00000 * 1e-4)
    assert_in_delta(0.87500, function.evaluate(4), 0.87500 * 1e-4)
    assert_in_delta(0.12500, function.evaluate(6), 0.12500 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(8), 0.00000 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(10), 0.00000 * 1e-4)
  end

end
