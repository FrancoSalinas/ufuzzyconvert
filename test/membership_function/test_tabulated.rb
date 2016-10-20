require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/tabulated'
include Mocha::API


class TabulatedTest < Test::Unit::TestCase

  def test_to_cfs_invalid_range_type
    function = UFuzzyConvert::MembershipFunction::Tabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range lower bound must be a number."
    ) do
      function.to_cfs("asd", 20, {:tsize => 8})
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range upper bound must be a number."
    ) do
      function.to_cfs(-20, "asd", {:tsize => 8})
    end
  end

  def test_to_cfs_range_swapped
    function = UFuzzyConvert::MembershipFunction::Tabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Range bounds are swapped."
    ) do
      function.to_cfs(-20, -40, {:tsize => 8})
    end
  end

  def test_to_cfs_invalid_table_size
    function = UFuzzyConvert::MembershipFunction::Tabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "options[:tsize] must be integer."
    ) do
      function.to_cfs(0, 1, {:tsize => "asd"})
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "options[:tsize] must be integer."
    ) do
      function.to_cfs(0, 1, {})
    end
  end

  def test_to_cfs_table_size_too_big
    function = UFuzzyConvert::MembershipFunction::Tabulated.new

    assert_raise_with_message(
      UFuzzyConvert::InputError,
        "options[:tsize] must be less or equal to 16."
    ) do
      function.to_cfs(0, 1, {:tsize => 17})
    end
  end

  def test_to_cfs_linear_with_small_table
    linear = UFuzzyConvert::MembershipFunction::Tabulated.new
    linear.define_singleton_method(:evaluate) do |x|
      return x
    end

    assert_equal(
      linear.to_cfs(0, 1, {:tsize => 4}),
      [
        0x01, 0x04,

        0x02, 0x00,
        0x06, 0x00,
        0x0A, 0x00,
        0x0E, 0x00,

        0x12, 0x00,
        0x16, 0x00,
        0x1A, 0x00,
        0x1E, 0x00,

        0x22, 0x00,
        0x26, 0x00,
        0x2A, 0x00,
        0x2E, 0x00,

        0x32, 0x00,
        0x36, 0x00,
        0x3A, 0x00,
        0x3E, 0x00
      ]
    )
  end

  def test_to_cfs_trapezoidal_with_small_table
    trapezoidal = UFuzzyConvert::MembershipFunction::Tabulated.new
    trapezoidal.define_singleton_method(:evaluate) do |x|
      if x < 1
        return x
      else
        return 1
      end
    end

    assert_equal(
      trapezoidal.to_cfs(0, 2, {:tsize => 4}),
      [
        0x01, 0x04,
        
        0x04, 0x00,
        0x0C, 0x00,
        0x14, 0x00,
        0x1C, 0x00,

        0x24, 0x00,
        0x2C, 0x00,
        0x34, 0x00,
        0x3C, 0x00,

        0x40, 0x00,
        0x40, 0x00,
        0x40, 0x00,
        0x40, 0x00,

        0x40, 0x00,
        0x40, 0x00,
        0x40, 0x00,
        0x40, 0x00
      ]
    )
  end
end
