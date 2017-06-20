require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/trapezoidal'
include Mocha::API


class TrapezoidalTest < Test::Unit::TestCase

  def test_parameter_number

    assert_equal(
      4, UFuzzyConvert::MembershipFunction::Trapezoidal::PARAMETER_NUMBER
    )
  end

  def test_to_cfs_invalid_range_type

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, "1", 2, 3, 4
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 1, "2", 3, 4
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 1, 2, "3", 4
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters must be numeric."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 1, 2, 3, "4"
      )
    end
  end

  def test_parameters_not_ordered
    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 2, 1, 3, 4
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 1, 3, 2, 4
      )
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(
        mock, 1, 2, 4, 3
      )
    end
  end

  def test_to_cfs
    variable_mock = mock('variable_mock')
    variable_mock
      .expects(:range_min)
      .returns(-8)
    variable_mock
      .expects(:range_max)
      .returns(8)

    function = UFuzzyConvert::MembershipFunction::Trapezoidal.new(
      variable_mock, -8, -4, 4, 8
    )

    assert_equal(
      function.to_cfs,
      [
        0x00, 0x00,
        0x00, 0x00,
        0x0F, 0xFF,
        0x2F, 0xFF,
        0x3F, 0xFF
      ]
    )
  end
end
