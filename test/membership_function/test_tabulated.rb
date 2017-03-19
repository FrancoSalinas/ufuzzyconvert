require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/tabulated'
include Mocha::API


class TabulatedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
    @variable_mock
      .expects(:range_min)
      .returns(0)
    @variable_mock
      .expects(:range_max)
      .returns(2)
  end

  def test_to_cfs_invalid_table_size
    function = UFuzzyConvert::MembershipFunction::Tabulated.new @variable_mock

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "options[:tsize] must be integer."
    ) do
      function.to_cfs({:tsize => "asd"})
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "options[:tsize] must be integer."
    ) do
      function.to_cfs({})
    end
  end

  def test_to_cfs_table_size_too_big
    function = UFuzzyConvert::MembershipFunction::Tabulated.new @variable_mock

    assert_raise_with_message(
      UFuzzyConvert::InputError,
        "options[:tsize] must be less or equal to 16."
    ) do
      function.to_cfs({:tsize => 17})
    end
  end

  def test_to_cfs_linear_with_small_table
    linear = UFuzzyConvert::MembershipFunction::Tabulated.new @variable_mock
    linear.define_singleton_method(:evaluate) do |x|
      return x / 2
    end

    assert_equal(
      linear.to_cfs({:tsize => 4}),
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
    trapezoidal = UFuzzyConvert::MembershipFunction::Tabulated.new(
      @variable_mock
    )
    trapezoidal.define_singleton_method(:evaluate) do |x|
      if x < 1
        return x
      else
        return 1
      end
    end

    assert_equal(
      trapezoidal.to_cfs({:tsize => 4}),
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
