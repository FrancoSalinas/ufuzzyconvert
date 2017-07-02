require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/gaussian'
include Mocha::API


class GaussianTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      2, UFuzzyConvert::MembershipFunction::Gaussian::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new @variable_mock, "1", 2
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new @variable_mock, 1, "2"
    end

    assert_raise(
      UFuzzyConvert::InputError.new "sig cannot be 0."
    ) do
      UFuzzyConvert::MembershipFunction::Gaussian.new @variable_mock, 0, 2
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::Gaussian.new(
      @variable_mock, 2, 5
    )

    assert_in_delta(0.043937, function.evaluate(0), 0.043937 * 1e-4)
    assert_in_delta(0.324652, function.evaluate(2), 0.324652 * 1e-4)
    assert_in_delta(0.882497, function.evaluate(4), 0.882497 * 1e-4)
    assert_in_delta(0.882497, function.evaluate(6), 0.882497 * 1e-4)
    assert_in_delta(0.324652, function.evaluate(8), 0.324652 * 1e-4)
    assert_in_delta(0.043937, function.evaluate(10), 0.043937 * 1e-4)
  end

end
