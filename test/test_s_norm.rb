require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/s_norm'
include Mocha::API


class SNormTest < Test::Unit::TestCase
  def test_from_fis_unrecognized_name
    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "asd s-norm not recognized."
    ) do
      UFuzzyConvert::SNorm.from_fis("asd")
    end
  end

  def test_from_fis_success
    assert_equal [0], UFuzzyConvert::SNorm.from_fis("max").to_cfs
    assert_equal [1], UFuzzyConvert::SNorm.from_fis("sum").to_cfs
    assert_equal [1], UFuzzyConvert::SNorm.from_fis("algebraic_sum").to_cfs
    assert_equal [2], UFuzzyConvert::SNorm.from_fis("bounded_sum").to_cfs
    assert_equal [3], UFuzzyConvert::SNorm.from_fis("drastic_sum").to_cfs
    assert_equal [4], UFuzzyConvert::SNorm.from_fis("einstein_sum").to_cfs
    assert_equal [5], UFuzzyConvert::SNorm.from_fis("hamacher_sum").to_cfs
  end

end
