require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/membership_function'
include Mocha::API


class MembershipFunctionTest < Test::Unit::TestCase

  def setup
    @membership_data = Hash.new

    @membership_data[:index] = 1
    @membership_data[:name] = "mf name"
    @membership_data[:type] = "rectmf"
    @membership_data[:parameters] = [1, 2]
  end

  def test_from_fis_data_missing_type
    @membership_data.delete :type

    assert_raise(
      UFuzzyConvert::InputError.new "Membership 1: Type not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data
    end
  end

  def test_from_fis_data_missing_name
    @membership_data.delete :name

    assert_raise(
      UFuzzyConvert::InputError.new "Membership 1: Name not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data

    end
  end

  def test_from_fis_data_missing_parameters
    @membership_data.delete :parameters

    assert_raise(
      UFuzzyConvert::InputError.new "Membership 1: Parameters not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data
    end
  end

  def test_from_fis_data_missing_index
    @membership_data.delete :index

    assert_raise(
      UFuzzyConvert::InputError.new "Membership function index not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data
    end
  end

  def test_from_fis_data_unsupported_type
    @membership_data[:type] = "nonexistent"

    assert_raise(
      UFuzzyConvert::FeatureError.new "Membership 1: nonexistent type not supported."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data
    end
  end

  def test_from_fis_data_unexpected_number_of_parameters
    @membership_data[:type] = "trapmf"
    @membership_data[:parameters] = [10, 20, 30]

    assert_raise(
      UFuzzyConvert::InputError.new "Membership 1: Must have at least 4 parameters."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data mock, @membership_data
    end
  end

  def test_from_fis_exception
    @membership_data[:parameters] = [10, 20]
    @membership_data[:name] = "rectangle"

    variable_mock = mock('variable_mock')

    UFuzzyConvert::MembershipFunction::Rectangular
      .expects(:new)
      .with(variable_mock, 10, 20, "rectangle")
      .raises(UFuzzyConvert::InputError, "msg.")
      .once

    assert_raise(
      UFuzzyConvert::InputError.new "Membership 1: msg."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(
        variable_mock, @membership_data
      )
    end

    UFuzzyConvert::MembershipFunction::Rectangular.unstub(:new)
  end

  def test_from_fis_data_success
    @membership_data[:parameters] = [10, 20]
    @membership_data[:name] = "rectangle"

    variable_mock = mock('variable_mock')

    rectangle_mock = mock("rectangle mock")
    UFuzzyConvert::MembershipFunction::Rectangular
      .expects(:new)
      .with(variable_mock, 10, 20, "rectangle")
      .returns(rectangle_mock)
      .once

    rect = UFuzzyConvert::MembershipFunction.from_fis_data(
      variable_mock, @membership_data
    )

    assert_equal rect, rectangle_mock

    UFuzzyConvert::MembershipFunction::Rectangular.unstub(:new)
  end

  def test_integration_with_non_tabulated
    @membership_data[:parameters] = [10, 20]

    variable_mock = mock('variable_mock')
    variable_mock
      .expects(:range_min)
      .returns(0)
    variable_mock
      .expects(:range_max)
      .returns(40)

    rect = UFuzzyConvert::MembershipFunction.from_fis_data(
      variable_mock, @membership_data
    )

    assert_equal rect.variable, variable_mock
    assert_equal(
      rect.to_cfs,
      [
        0x00, 0x00,
        0x0F, 0xFF,
        0x0F, 0xFF,
        0x1F, 0xFF,
        0x1F, 0xFF,
      ]
    )
  end

  def test_integration_with_tabulated
    @membership_data[:parameters] = [3, 7]
    @membership_data[:type] = "zmf"

    variable_mock = mock('variable_mock')

    function = UFuzzyConvert::MembershipFunction.from_fis_data(
      variable_mock, @membership_data
    )

    assert_equal function.variable, variable_mock
    assert_in_delta(1.00000, function.evaluate(0), 1.00000 * 1e-4)
    assert_in_delta(1.00000, function.evaluate(2), 1.00000 * 1e-4)
    assert_in_delta(0.87500, function.evaluate(4), 0.87500 * 1e-4)
    assert_in_delta(0.12500, function.evaluate(6), 0.12500 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(8), 0.00000 * 1e-4)
    assert_in_delta(0.00000, function.evaluate(10), 0.00000 * 1e-4)
  end
end
