require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/sigmoid_product'
include Mocha::API


class SigmoidProductTest < Test::Unit::TestCase

  def test_parameter_number

    assert_equal(
      4, UFuzzyConvert::MembershipFunction::SigmoidProduct::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidProduct.new "1", 2, 3, 4
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidProduct.new 1, "2", 3, 4
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidProduct.new 1, 2, "3", 4
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SigmoidProduct.new 1, 2, 3, "4"
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::SigmoidProduct.new(
      2, 3, -5, 8
    )

    assert_in_delta(2.4726e-03, function.evaluate(0), 2.4726e-03 * 1e-4)
    assert_in_delta(1.1920e-01, function.evaluate(2), 1.1920e-01 * 1e-4)
    assert_in_delta(8.8080e-01, function.evaluate(4), 8.8080e-01 * 1e-4)
    assert_in_delta(9.9748e-01, function.evaluate(6), 9.9748e-01 * 1e-4)
    assert_in_delta(4.9998e-01, function.evaluate(8), 4.9998e-01 * 1e-4)
    assert_in_delta(4.5398e-05, function.evaluate(10), 4.5398e-05 * 1e-4)
  end

end
