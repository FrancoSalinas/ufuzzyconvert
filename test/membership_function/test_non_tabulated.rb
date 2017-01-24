require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/non_tabulated'
include Mocha::API


class NonTabulatedTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
    @variable_mock
      .expects(:range_min)
      .returns(-4)
    @variable_mock
      .expects(:range_max)
      .returns(4)
  end

  def test_to_cfs_trapezoidal
    trapezoidal = UFuzzyConvert::MembershipFunction::NonTabulated.new(
      @variable_mock
    )
    trapezoidal.instance_variable_set("@xs", [-1, 1, 2, 4])

    assert_equal(
      trapezoidal.to_cfs,
      [
        0x00, 0x00,
        0x18, 0x00,
        0x28, 0x00,
        0x30, 0x00,
        0x40, 0x00,
      ]
    )
  end
end
