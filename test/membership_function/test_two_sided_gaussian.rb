require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/two_sided_gaussian'
include Mocha::API


class TwoSidedGaussianTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      4, UFuzzyConvert::MembershipFunction::TwoSidedGaussian::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, "1", 2, 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, 1, "2", 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, 1, 2, "3", 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, 1, 2, 3, "4"
      )
    end
  end

  def test_sigma_zero
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "sig1 cannot be 0."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, 0, 2, 3, 4
      )
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "sig2 cannot be 0."
    ) do
      UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
        @variable_mock, 1, 2, 0, 4
      )
    end

  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
      @variable_mock, 2, 8, 1, 4
    )

    assert_in_delta(3.3546e-04, function.evaluate(0), 3.3546e-04 * 1e-4)
    assert_in_delta(1.1109e-02, function.evaluate(2), 1.1109e-02 * 1e-4)
    assert_in_delta(1.3534e-01, function.evaluate(4), 1.3534e-01 * 1e-4)
    assert_in_delta(8.2085e-02, function.evaluate(6), 8.2085e-02 * 1e-4)
    assert_in_delta(3.3546e-04, function.evaluate(8), 3.3546e-04 * 1e-4)
    assert_in_delta(1.5230e-08, function.evaluate(10), 1.5230e-08 * 1e-4)

    function = UFuzzyConvert::MembershipFunction::TwoSidedGaussian.new(
      @variable_mock, 2, 4, 1, 8
    )

    assert_in_delta(0.13534, function.evaluate(0), 0.13534 * 1e-4)
    assert_in_delta(0.60653, function.evaluate(2), 0.60653 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(4), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(6), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(8), 1.00000 * 1e-4)
    assert_in_delta(0.13534, function.evaluate(10), 0.13534 * 1e-4)
  end

end
