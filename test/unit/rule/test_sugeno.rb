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

  def test_output_limits_for_linear
    variable_mock_1 = mock('variable_mock_1')
    variable_mock_1
      .expects(:range_min)
      .returns(-3)
    variable_mock_1
      .expects(:range_max)
      .returns(-1)

    membership_function_mock_1 = mock('membership_function_mock_1')
    membership_function_mock_1
      .expects(:variable)
      .returns(variable_mock_1)

    proposition_mock_1 = mock('proposition_mock_1')
    proposition_mock_1
      .expects(:membership_function)
      .returns(membership_function_mock_1)

    variable_mock_2 = mock('variable_mock_2')
    variable_mock_2
      .expects(:range_min)
      .returns(0)
    variable_mock_2
      .expects(:range_max)
      .returns(0.5)

    membership_function_mock_2 = mock('membership_function_mock_2')
    membership_function_mock_2
      .expects(:variable)
      .returns(variable_mock_2)

    proposition_mock_2 = mock('proposition_mock_2')
    proposition_mock_2
      .expects(:membership_function)
      .returns(membership_function_mock_2)

    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:instance_of?)
      .returns(false)
    consequent_mock
      .expects(:coefficients)
      .returns([-1.0, 2.0])
    consequent_mock
      .expects(:independent_term)
      .returns(0.5)

    rule = UFuzzyConvert::SugenoRule.new(
      [proposition_mock_1, proposition_mock_2],
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal [1.5, 4.5], rule.output_limits
  end

  def test_output_limits_for_constant
    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:instance_of?)
      .returns(true)
    consequent_mock
      .expects(:constant)
      .returns(0.5)
      .at_least_once

    rule = UFuzzyConvert::SugenoRule.new(
      [mock, mock],
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal [0.5, 0.5], rule.output_limits
  end

  def test_coefficient_overflow
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map).twice

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([[-2.0, 2.0, -3.0], 0])
      .then
      .returns([[0.0, 2.0, -2.0], 0])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal(-1.5, rule.coefficient_overflow(0, 1.0))

    overflow = rule.coefficient_overflow(0, 1.0)
    assert_true overflow > 1.00
    assert_true overflow < 1.01
  end

  def test_fit_independent_term_when_no_fitting_needed
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map)

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([nil, -2])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal [0, 1], rule.fit_independent_term(0, 1.0, 1.0)
  end

  def test_fit_independent_term_when_only_scaling_needed
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map)

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([nil, -2])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    assert_equal [-2, 2], rule.fit_independent_term(-1.0, 1.0, 2.0)
  end

  def test_fit_independent_term_when_scaling_is_bigger
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map)

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([nil, -3])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    # -3 does not fit the original range, but it must be scaled * 3.0 anyway.
    assert_equal [-1, 2], rule.fit_independent_term(0, 1.0, 3.0)
  end

  def test_fit_independent_term_when_scaling_is_bigger_with_displacement
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map).at_least_once

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([nil, -8.0])
      .then
      .returns([nil, -2.0])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    # -8.0 does not fit the original range, but it must be scaled * 3.0 anyway.
    assert_equal [-2, 1], rule.fit_independent_term(0, 1.0, 3.0)
  end

  def test_fit_independent_term_when_does_not_fit_after_scaling
    antecedent_mock = mock('antecedent')
    antecedent_mock.expects(:map).at_least_once

    consequent_mock = mock('consequent')
    consequent_mock
      .stubs(:normalize)
      .returns([nil, -6.0])
      .then
      .returns([nil, -2.5])

    rule = UFuzzyConvert::SugenoRule.new(
      antecedent_mock,
      consequent_mock,
      UFuzzyConvert::TNormMinimum.new,
      0.75
    )

    # -6.0 does not fit the original range. It must be scaled * 2.0 because of
    # the coefficients, but even then it does not fit. The range needs to be
    # scaled again.
    assert_equal [-1.5, 1], rule.fit_independent_term(0, 1.0, 2.0)
  end
end
