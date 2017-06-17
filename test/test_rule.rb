require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class RuleTest < Test::Unit::TestCase

  def setup
    @weight = 0.7
    @rule_data = {
      :antecedent => [1, -2, 0],
      :consequent => [0, 1],
      :connective => 1,
      :weight => @weight
    }
    @inputs_mock = [
      mock('input_mock_1'),
      mock('input_mock_2'),
      mock('input_mock_3')
    ]
    @output_mock = mock('outuput_mock')
    @connective_mock = mock('connective')
  end

  def test_from_fis_missing_antecedent
    @rule_data.delete :antecedent
    assert_raise(
      UFuzzyConvert::InputError.new "Rule antecedent not defined."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_from_fis_missing_consequent
    @rule_data.delete :consequent
    assert_raise(
      UFuzzyConvert::InputError.new "Rule consequent not defined."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_from_fis_missing_connective
    @rule_data.delete :connective
    assert_raise(
      UFuzzyConvert::InputError.new "Rule connective not defined."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_from_fis_missing_weight
    @rule_data.delete :weight
    assert_raise(
      UFuzzyConvert::InputError.new "Rule weight not defined."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_from_fis_wrong_antecedent_size
    @rule_data[:antecedent] = [1, 1]

    assert_raise(
      UFuzzyConvert::InputError.new "Rule antecedent should have 3 propositions."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_from_fis_wrong_consequent_size
    UFuzzyConvert::Proposition
      .expects(:from_fis_data)
      .returns(mock())
      .times(@inputs_mock.size)

    @output_mock
      .expects(:index)
      .returns(3)
      .at_least_once

    assert_raise(
      UFuzzyConvert::InputError.new "Rule consequent should have at least 3 propositions."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
    UFuzzyConvert::Proposition.unstub(:from_fis_data)
  end

  def test_from_fis_negated_consequent
    UFuzzyConvert::Proposition
      .expects(:from_fis_data)
      .returns(mock())
      .times(@inputs_mock.size)

    @output_mock
      .expects(:index)
      .returns(1)
      .at_least_once

    @rule_data[:consequent] = [-1, 0]

    assert_raise(
      UFuzzyConvert::FeatureError.new "Negated consequents are not supported."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
    UFuzzyConvert::Proposition.unstub(:from_fis_data)
  end

  def test_from_fis_invalid_membership_function
    UFuzzyConvert::Proposition
      .expects(:from_fis_data)
      .returns(mock())
      .times(@inputs_mock.size)

    @output_mock
      .expects(:index)
      .returns(1)
      .at_least_once
    @output_mock
      .expects(:membership_functions)
      .returns([mock()])

    @rule_data[:consequent] = [2, 0]

    assert_raise(
      UFuzzyConvert::InputError.new "Membership function index 2 is not valid for output 1."
    ) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
    UFuzzyConvert::Proposition.unstub(:from_fis_data)
  end

  def test_from_fis_nil_rule
    UFuzzyConvert::Proposition
      .expects(:from_fis_data)
      .returns(mock())
      .times(@inputs_mock.size)

    @output_mock
      .expects(:index)
      .returns(1)
      .at_least_once

    rule =  UFuzzyConvert::Rule.from_fis_data(
      @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
    )

    assert_nil rule
    UFuzzyConvert::Proposition.unstub(:from_fis_data)
  end

  def test_from_fis_success
    proposition_mock = mock('proposition')
    UFuzzyConvert::Proposition
      .expects(:from_fis_data)
      .returns(proposition_mock)
      .times(@inputs_mock.size)

    UFuzzyConvert::Connective
      .expects(:from_fis_data)
      .returns(@connective_mock)

    consequent_mock = mock('consequent')
    @output_mock
      .expects(:index)
      .returns(2)
      .at_least_once
    @output_mock
      .expects(:membership_functions)
      .returns([consequent_mock])
      .at_least_once

    rule =  UFuzzyConvert::Rule.from_fis_data(
      @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
    )

    assert_equal(
      [proposition_mock, proposition_mock, proposition_mock], rule.antecedent
    )
    assert(consequent_mock == rule.consequent)
    assert_equal @connective_mock, rule.connective
    assert_equal @weight, rule.weight

    UFuzzyConvert::Proposition.unstub(:from_fis_data)
    UFuzzyConvert::Connective.unstub(:from_fis_data)
  end

  def test_integration_with_connective
    @rule_data[:connective] = 3
    assert_raise(UFuzzyConvert::FeatureError) do
      UFuzzyConvert::Rule.from_fis_data(
        @output_mock, @inputs_mock, @and_mock, @or_mock, @rule_data
      )
    end
  end

  def test_integration_without_output


    consequent_mock = mock('consequent')
    @output_mock
      .expects(:index)
      .returns(2)
      .at_least_once
    @output_mock
      .expects(:membership_functions)
      .returns([consequent_mock])
      .at_least_once

    inputs = [
      UFuzzyConvert::InputVariable.new(0, 10),
      UFuzzyConvert::InputVariable.new(0, 10),
      UFuzzyConvert::InputVariable.new(0, 10)
    ]

    inputs[0].membership_functions = [
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(inputs[0], 0, 1, 2, 3)
    ]

    inputs[1].membership_functions = [
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(inputs[1], 0, 2, 4, 6),
      UFuzzyConvert::MembershipFunction::Trapezoidal.new(inputs[1], 4, 6, 8, 10)
    ]

    rule =  UFuzzyConvert::Rule.from_fis_data(
      @output_mock,
      inputs,
      UFuzzyConvert::TNormMinimum.new,
      UFuzzyConvert::SNormMaximum.new,
      @rule_data
    )

    assert_equal 3, rule.antecedent.size

    assert_equal(
      inputs[0].membership_functions[0],
      rule.antecedent[0].membership_function
    )
    assert_equal(false, rule.antecedent[0].negated)

    assert_equal(
      inputs[1].membership_functions[1],
      rule.antecedent[1].membership_function
    )
    assert_equal(true, rule.antecedent[1].negated)

    assert_equal(
      UFuzzyConvert::MembershipFunction::Any.new(inputs[2]),
      rule.antecedent[2].membership_function
    )
    assert_equal(false, rule.antecedent[2].negated)

    assert(consequent_mock == rule.consequent)
    assert(
      rule.connective.is_a?(UFuzzyConvert::TNormMinimum),
      "Connective should be TNormMinimum."
    )
    assert_equal @weight, rule.weight
  end

end
