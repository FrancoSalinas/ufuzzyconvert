require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class PropositionTest < Test::Unit::TestCase

  def test_from_fis_membership_function_index_not_found

    input_mock = mock('input_mock')
    input_mock
      .expects(:index)
      .with()
      .returns(2)

    input_mock
      .expects(:membership_functions)
      .with()
      .returns([])

    assert_raise(
      UFuzzyConvert::InputError.new "Membership function index 1 is not valid "\
                                 "for input 2."
    ) do
      UFuzzyConvert::Proposition.from_fis_data(input_mock, 1)
    end
  end

  def test_success

    input_mock = mock('input_mock')
    input_mock
      .expects(:index)
      .with()
      .returns(2)
      .twice

    membership_function_mock = mock('membership_function')
    membership_function_mock
      .expects(:index)
      .with()
      .returns(1)
      .twice

    input_mock
      .expects(:membership_functions)
      .with()
      .returns([membership_function_mock])
      .twice

    proposition = UFuzzyConvert::Proposition.from_fis_data(input_mock, 1)

    assert_equal membership_function_mock, proposition.membership_function
    assert_equal false, proposition.negated
    assert_equal [1], proposition.to_cfs

    proposition = UFuzzyConvert::Proposition.from_fis_data(input_mock, -1)

    assert_equal membership_function_mock, proposition.membership_function
    assert_equal true, proposition.negated
    assert_equal [-1], proposition.to_cfs
  end

  def test_integration_with_membership_function_any

    input_mock = mock('input_mock')

    proposition = UFuzzyConvert::Proposition.from_fis_data(input_mock, 0)

    assert_equal(
      UFuzzyConvert::MembershipFunction::Any.new(input_mock),
      proposition.membership_function
    )
    assert_equal [0], proposition.to_cfs

  end

  def test_integration_with_input_variable_and_membership_function
    input = UFuzzyConvert::InputVariable.new(
      -10, 10
    )

    membership_function_1 = UFuzzyConvert::MembershipFunction::Triangular.new(
      input, -10, -10, -5
    )
    membership_function_2 = UFuzzyConvert::MembershipFunction::Trapezoidal.new(
      input, -10, -5, 5, 10
    )
    membership_function_3 = UFuzzyConvert::MembershipFunction::Triangular.new(
      input, 5, 10, 10
    )

    input.membership_functions = [
      membership_function_1, membership_function_2, membership_function_3
    ]

    proposition = UFuzzyConvert::Proposition.from_fis_data(input, 2)

    assert_equal membership_function_2, proposition.membership_function
    assert_equal false, proposition.negated
    assert_equal [2], proposition.to_cfs


    proposition = UFuzzyConvert::Proposition.from_fis_data(input, -3)

    assert_equal membership_function_3, proposition.membership_function
    assert_equal true, proposition.negated
    assert_equal [-3], proposition.to_cfs

    proposition = UFuzzyConvert::Proposition.from_fis_data(input, 0)

    assert_equal(
      UFuzzyConvert::MembershipFunction::Any.new(input),
      proposition.membership_function
    )
    assert_equal [0], proposition.to_cfs
  end

end
