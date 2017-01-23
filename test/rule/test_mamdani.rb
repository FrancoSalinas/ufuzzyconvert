require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/fuzzy_system'
include Mocha::API


class RuleTest < Test::Unit::TestCase

  def test_to_cfs
    proposition_mock_1 = mock('proposition_mock_1')
    proposition_mock_1
      .expects(:to_cfs)
      .returns(1)

    proposition_mock_2 = mock('proposition_mock_2')
    proposition_mock_2
      .expects(:to_cfs)
      .returns(0)

    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:index)
      .returns(3)

    rule = UFuzzyConvert::MamdaniRule.new(
      [proposition_mock_1, proposition_mock_2],
      consequent_mock,
      UFuzzyConvert::SNormMaximum.new,
      0.75
    )

    assert_equal [1, 1, 0, 3], rule.to_cfs
  end

  def test_to_cfs_with_padding
    proposition_mock_1 = mock('proposition_mock_1')
    proposition_mock_1
      .expects(:to_cfs)
      .returns(1)

    consequent_mock = mock('consequent')
    consequent_mock
      .expects(:index)
      .returns(3)

    rule = UFuzzyConvert::MamdaniRule.new(
      [proposition_mock_1],
      consequent_mock,
      UFuzzyConvert::SNormMaximum.new,
      0.75
    )

    assert_equal [1, 1, 3, 0], rule.to_cfs
  end

end
