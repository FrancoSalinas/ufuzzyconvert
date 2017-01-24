require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function/triangular'
include Mocha::API


class TriangularTest < Test::Unit::TestCase

  def setup
    @variable_mock = mock('variable_mock')
    @variable_mock
      .expects(:range_min)
      .returns(0)
    @variable_mock
      .expects(:range_max)
      .returns(4)
  end

  def test_parameter_number

    assert_equal(
      3, UFuzzyConvert::MembershipFunction::Triangular::PARAMETER_NUMBER
    )
  end

  def test_parameters_not_ordered
    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Triangular.new @variable_mock, 2, 1, 3
    end

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Parameters are not ordered."
    ) do
      UFuzzyConvert::MembershipFunction::Triangular.new @variable_mock, 1, 3, 2
    end
  end

  def test_to_cfs
    function = UFuzzyConvert::MembershipFunction::Triangular.new(
      @variable_mock, 1, 2, 3
    )

    assert_equal(
      function.to_cfs,
      [
        0x00, 0x00,
        0x10, 0x00,
        0x20, 0x00,
        0x20, 0x00,
        0x30, 0x00,
      ]
    )
  end
end
