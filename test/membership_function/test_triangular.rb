require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/membership_function/triangular'
include Mocha::API


class TriangularTest < Test::Unit::TestCase

  def test_parameter_number
    assert_equal(
      3, UFuzzyConvert::MembershipFunction::Triangular::PARAMETER_NUMBER
    )
  end

  def test_parameters_not_ordered
    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Triangular.new mock, 2, 1, 3
    end

    assert_raise(
      UFuzzyConvert::InputError.new "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Triangular.new mock, 1, 3, 2
    end
  end

  def test_to_cfs
    variable_mock = mock('variable_mock')
    variable_mock
      .expects(:range_min)
      .returns(0)
    variable_mock
      .expects(:range_max)
      .returns(4)

    function = UFuzzyConvert::MembershipFunction::Triangular.new(
      variable_mock, 1, 2, 3
    )

    assert_equal(
      function.to_cfs,
      [
        0x00, 0x00,
        0x0F, 0xFF,
        0x1F, 0xFF,
        0x1F, 0xFF,
        0x2F, 0xFF,
      ]
    )
  end
end
