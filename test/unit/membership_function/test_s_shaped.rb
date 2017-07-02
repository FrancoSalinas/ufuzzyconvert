require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/s_shaped'
include Mocha::API


class SShapedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_parameter_number

    assert_equal(
      2, UFuzzyConvert::MembershipFunction::SShaped::PARAMETER_NUMBER
    )
  end

  def test_invalid_parameters
    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new @variable_mock, "1", 2
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new @variable_mock, 1, "2"
    end

  end

  def test_parameters_not_ordered
    assert_raise(
      UFuzzyConvert::InputError.new "a must be lower than b."
    ) do
      UFuzzyConvert::MembershipFunction::SShaped.new @variable_mock, 2, 1
    end
  end

  def test_evaluate
    function = UFuzzyConvert::MembershipFunction::SShaped.new(
      @variable_mock, 1, 8
    )

    assert_in_delta(0.00000, function.evaluate(0), 0.00000 * 1e-4)
    assert_in_delta(0.04082, function.evaluate(2), 0.04082 * 1e-4)
    assert_in_delta(0.36735, function.evaluate(4), 0.36735 * 1e-4)
    assert_in_delta(0.83673, function.evaluate(6), 0.83673 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(8), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(10), 1.00000 * 1e-4)
  end

end
