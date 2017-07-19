require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/constant'
include Mocha::API


class ConstantTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
  end

  def test_to_cfs_out_of_range
    @variable_mock
      .expects(:range_min)
      .returns(-4)
    @variable_mock
      .expects(:range_max)
      .returns(4)

    constant = UFuzzyConvert::MembershipFunction::Constant.new(
      @variable_mock, 12, "name"
    )

    inputs = [mock]

    assert_raise(
      UFuzzyConvert::FixedPointError.new "Fixed point value out of range."
    ) do
      constant.to_cfs(inputs)
    end
  end

  def test_to_cfs_success
    @variable_mock
      .expects(:range_min)
      .returns(-4)
    @variable_mock
      .expects(:range_max)
      .returns(4)

    constant = UFuzzyConvert::MembershipFunction::Constant.new(
      @variable_mock, 4, "name"
    )

    inputs = [mock]

    assert_equal [0x40, 0x00, 0x00, 0x00], constant.to_cfs(inputs)

  end

  def test_normalize
    constant = UFuzzyConvert::MembershipFunction::Constant.new(
      @variable_mock, 4, "name"
    )

    coefficients, independent = constant.normalize([mock, mock], -4, 4)

    assert_equal coefficients, [0, 0]
    assert_equal independent, 1

    constant = UFuzzyConvert::MembershipFunction::Constant.new(
      @variable_mock, 4, "name"
    )

    coefficients, independent = constant.normalize([mock, mock], -4, 4)

    assert_equal [0, 0], coefficients
    assert_equal 1, independent
  end
end
