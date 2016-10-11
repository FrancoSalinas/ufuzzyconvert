require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fixed_point'
include Mocha::API


class FixedPointTest < Test::Unit::TestCase

  def test_to_cfs_out_of_range
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Fixed point value out of range."
    ) do
      -20.5.to_cfs(0, 10)
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Fixed point value out of range."
    ) do
      20.to_cfs(0, 10)
    end
  end

  def test_to_cfs_success
    assert_equal 0.to_cfs(0, 10), [0, 0]
    assert_equal 5.to_cfs(0, 10), [32, 0]
    assert_equal 10.to_cfs(0, 10), [64, 0]

    assert_equal 0.to_cfs(-1, 1), [32, 0]

    assert_equal 0.to_cfs(0, 1), [0, 0]
    assert_equal 0.5.to_cfs(0, 1), [32, 0]
    assert_equal 1.to_cfs(0, 1), [64, 0]

    assert_equal(-350.to_cfs(-300, -100), [0xF0, 0])
    assert_equal(-250.to_cfs(-300, -100), [0x10, 0])
    assert_equal(-200.to_cfs(-300, -100), [0x20, 0])
    assert_equal(-150.to_cfs(-300, -100), [0x30, 0])
    assert_equal(-50.to_cfs(-300, -100), [0x50, 0])
  end

end
