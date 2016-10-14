require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/gaussian'
include Mocha::API


class GaussianTest < Test::Unit::TestCase

  def test_parameter_number

    assert_equal(
      2, UFuzzyConvert::MembershipFunction::Gaussian::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new "1", 2
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new 1, "2"
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "sig cannot be 0."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new 0, 2
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::Gaussian.new 2, 5

    assert_in_delta(0.043937, function.evaluate(0), 0.043937 * 1e-4)
    assert_in_delta(0.324652, function.evaluate(2), 0.324652 * 1e-4)
    assert_in_delta(0.882497, function.evaluate(4), 0.882497 * 1e-4)
    assert_in_delta(0.882497, function.evaluate(6), 0.882497 * 1e-4)
    assert_in_delta(0.324652, function.evaluate(8), 0.324652 * 1e-4)
    assert_in_delta(0.043937, function.evaluate(10), 0.043937 * 1e-4)
  end

end
