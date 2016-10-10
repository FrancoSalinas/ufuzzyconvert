require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/t_norm'
include Mocha::API


class TNormTest < Test::Unit::TestCase
  def test_from_fis_unrecognized_name
    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "asd t-norm not recognized."
    ) do
      UFuzzyConvert::TNorm.from_fis("asd")
    end
  end

  def test_from_fis_success
    assert_equal [0], UFuzzyConvert::TNorm.from_fis("min").to_cfs
    assert_equal [1], UFuzzyConvert::TNorm.from_fis("prod").to_cfs
    assert_equal [1], UFuzzyConvert::TNorm.from_fis("algebraic_product").to_cfs
    assert_equal [2], UFuzzyConvert::TNorm.from_fis("bounded_difference").to_cfs
    assert_equal [3], UFuzzyConvert::TNorm.from_fis("drastic_product").to_cfs
    assert_equal [4], UFuzzyConvert::TNorm.from_fis("einstein_product").to_cfs
    assert_equal [5], UFuzzyConvert::TNorm.from_fis("hamacher_product").to_cfs
  end
  
end
