require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/non_tabulated'
include Mocha::API


class NonTabulatedTest < Test::Unit::TestCase

  def test_to_cfs_invalid_range_type
    function = UFuzzyConvert::MembershipFunction::NonTabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range lower bound must be a number."
    ) do
      function.to_cfs("asd", 20)
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range upper bound must be a number."
    ) do
      function.to_cfs(-20, "asd")
    end
  end

  def test_to_cfs_range_swapped
    function = UFuzzyConvert::MembershipFunction::NonTabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range bounds are swapped."
    ) do
      function.to_cfs(-20, -40)
    end
  end

  def test_to_cfs_trapezoidal
    trapezoidal = UFuzzyConvert::MembershipFunction::NonTabulated.new
    trapezoidal.instance_variable_set("@xs", [-1, 1, 2, 4])

    assert_equal(
      trapezoidal.to_cfs(-4, 4),
      [
        0x18, 0x00,
        0x28, 0x00,
        0x30, 0x00,
        0x40, 0x00,
      ]
    )
  end
end
