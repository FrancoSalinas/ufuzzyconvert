require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/fuzzy_system'
include Mocha::API


class SugenoRuleTest < Test::Unit::TestCase

  def test_to_cfs
    variable_mock_1 = mock('variable_mock_1')

    membership_function_mock_1 = mock('membership_function_mock_1')
    membership_function_mock_1
      .expects(:variable)
      .returns(variable_mock_1)

    proposition_mock_1 = mock('proposition_mock_1')
    proposition_mock_1
      .expects(:to_cfs)
      .returns(1)
    proposition_mock_1
      .expects(:membership_function)
      .returns(membership_function_mock_1)

    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:to_cfs)
      .with([variable_mock_1])
      .returns([0x33, 0x66])

    rule = UFuzzyConvert::SugenoRule.new(
      [proposition_mock_1],
      consequent_mock,
      UFuzzyConvert::SNormMaximum.new,
      0.75
    )

    assert_equal [1, 1, 0x33, 0x66], rule.to_cfs
  end

  def test_to_cfs_with_padding
    variable_mock_1 = mock('variable_mock_1')

    membership_function_mock_1 = mock('membership_function_mock_1')
    membership_function_mock_1
      .expects(:variable)
      .returns(variable_mock_1)

    proposition_mock_1 = mock('proposition_mock_1')
    proposition_mock_1
      .expects(:to_cfs)
      .returns(1)
    proposition_mock_1
      .expects(:membership_function)
      .returns(membership_function_mock_1)

    variable_mock_2 = mock('variable_mock_2')

    membership_function_mock_2 = mock('membership_function_mock_2')
    membership_function_mock_2
      .expects(:variable)
      .returns(variable_mock_2)

    proposition_mock_2 = mock('proposition_mock_2')
    proposition_mock_2
      .expects(:to_cfs)
      .returns(0)
    proposition_mock_2
      .expects(:membership_function)
      .returns(membership_function_mock_2)

    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:to_cfs)
      .with([variable_mock_1, variable_mock_2])
      .returns([0x33, 0x66])

    rule = UFuzzyConvert::SugenoRule.new(
      [proposition_mock_1, proposition_mock_2],
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal [0, 1, 0, 0, 0x33, 0x66], rule.to_cfs
  end
end
