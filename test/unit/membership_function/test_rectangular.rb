require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/rectangular'
include Mocha::API


class RectangleTest < Test::Unit::TestCase

  def test_parameter_number
    assert_equal(
      2, UFuzzyConvert::MembershipFunction::Rectangular::PARAMETER_NUMBER
    )
  end

  def test_to_cfs_invalid_range_type

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Rectangular.new mock, "1", 2
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Rectangular.new mock, 1, "2"
    end
  end

  def test_parameters_not_ordered
    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Rectangular.new mock, 2, 1
    end
  end

  def test_to_cfs
    variable_mock = mock('variable_mock')
    variable_mock
      .expects(:range_min)
      .returns(-4)
    variable_mock
      .expects(:range_max)
      .returns(4)

    function = UFuzzyConvert::MembershipFunction::Rectangular.new(
      variable_mock, 1, 2
    )

    assert_equal(
      function.to_cfs,
      [
        0x00, 0x00,
        0x27, 0xFF,
        0x27, 0xFF,
        0x2F, 0xFF,
        0x2F, 0xFF,
      ]
    )
  end
end
