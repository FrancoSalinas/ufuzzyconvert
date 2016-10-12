require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/z_shaped'
include Mocha::API


class ZShapedTest < Test::Unit::TestCase

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new "1", 2
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new 1, "2"
    end

  end

  def test_parameters_not_ordered
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "a must be lower than b."
    ) do
      UFuzzyConvert::MembershipFunction::ZShaped.new 2, 1
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::ZShaped.new 3, 7

    assert_in_delta(1.00000, function.evaluate(0), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(2), 1.00000 * 1e-4)
    assert_in_delta(0.87500, function.evaluate(4), 0.87500 * 1e-4)
    assert_in_delta(0.12500, function.evaluate(6), 0.12500 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(8), 0.00000 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(10), 0.00000 * 1e-4)
  end

end
