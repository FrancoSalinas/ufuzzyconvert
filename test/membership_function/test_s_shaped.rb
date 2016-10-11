require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/s_shaped'
include Mocha::API


class SShapedTest < Test::Unit::TestCase

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new "1", 2
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new 1, "2"
    end

  end

  def test_parameters_not_ordered
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "a must be lower than b."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new 2, 1
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::SShaped.new 1, 8

    assert_in_delta(0.00000, function.evaluate(0), 0.00000 * 1e-4)
    assert_in_delta(0.04082, function.evaluate(2), 0.04082 * 1e-4)
    assert_in_delta(0.36735, function.evaluate(4), 0.36735 * 1e-4)
    assert_in_delta(0.83673, function.evaluate(6), 0.83673 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(8), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(10), 1.00000 * 1e-4)
  end

end
