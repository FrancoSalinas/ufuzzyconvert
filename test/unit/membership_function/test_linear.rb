require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/linear'
include Mocha::API


class LinearTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')

    @input_mock = mock('input')
    @input_mock
      .expects(:range_min)
      .returns(-1000)
      .at_least_once
    @input_mock
      .expects(:range_max)
      .returns(-200)
      .at_least_once

  end

  def test_to_cfs_independent_term_out_of_range
    @variable_mock
      .expects(:range_min)
      .returns(-4)
      .at_least_once
    @variable_mock
      .expects(:range_max)
      .returns(4)
      .at_least_once
    # A0' = sum(Ak*Ikmin)/delta(0) + (A0-Omin)/delta(O)

    linear = UFuzzyConvert::MembershipFunction::Linear.new(
      @variable_mock, [0.0192, -1], "name"
    )

    # A0' = (0.0192*-1000)/8 + (-1-(-4))/8 = -2.025

    inputs = [@input_mock]

    assert_raise(
      UFuzzyConvert::FixedPointError.new "Independent term: Fixed point value out of range."
    ) do
      linear.to_cfs(inputs)
    end
  end

  def test_to_cfs_success
    @variable_mock
      .expects(:range_min)
      .returns(-4)
      .at_least_once
    @variable_mock
      .expects(:range_max)
      .returns(4)
      .at_least_once
    # A0' = sum(Ak*Ikmin)/delta(0) + (A0-Omin)/delta(O)

    linear = UFuzzyConvert::MembershipFunction::Linear.new(
      @variable_mock, [0.019, -1], "name"
    )

    # A0' = (-0.019*1000)/8 + (-1-(-4))/8 = -2.000

    inputs = [@input_mock]

    assert_equal [0x80, 0x00, 0x79, 0x9A], linear.to_cfs(inputs)

  end

  def test_normalize
    linear = UFuzzyConvert::MembershipFunction::Linear.new(
      @variable_mock, [0.01, 0], "name"
    )

    inputs = [@input_mock]

    coefficients, independent = linear.normalize(inputs, -4, 4)

    assert_equal [1.0], coefficients
    assert_equal(-0.75, independent)
  end
end
