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

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership 1: Type not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_missing_name
    @membership_data.delete :name

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership 1: Name not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_missing_parameters
    @membership_data.delete :parameters

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership 1: Parameters not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_missing_index
    @membership_data.delete :index

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership function index not defined."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_unsupported_type
    @membership_data[:type] = "nonexistent type"

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Membership 1: Type not supported."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_unexpected_number_of_parameters
    @membership_data[:type] = "rectmf"
    @membership_data[:parameters] = [10, 20, 30]

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership 1: Unexpected number of parameters."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_exception
    @membership_data[:parameters] = [10, 20]
    @membership_data[:name] = "rectangle"

    UFuzzyConvert::MembershipFunction::Rectangular
      .expects(:new)
      .with(10, 20, "rectangle")
      .raises(UFuzzyConvert::InputError, "msg.")
      .once

    assert_raise_with_message(
      UFuzzyConvert::InputError,
      "Membership 1: msg."
    ) do
      UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)
    end
  end

  def test_from_fis_data_success
    @membership_data[:parameters] = [10, 20]
    @membership_data[:name] = "rectangle"

    rectangle_mock = mock("rectangle mock")
    UFuzzyConvert::MembershipFunction::Rectangular
      .expects(:new)
      .with(10, 20, "rectangle")
      .returns(rectangle_mock)
      .once

    rect = UFuzzyConvert::MembershipFunction.from_fis_data(@membership_data)

    assert_equal rect, rectangle_mock
  end

end
