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
    tnorm = UFuzzyConvert::TNorm.from_fis("min")
    assert tnorm.is_a? UFuzzyConvert::TNormMinimum
    assert_equal [0], tnorm.to_cfs


    tnorm = UFuzzyConvert::TNorm.from_fis("prod")
    assert tnorm.is_a? UFuzzyConvert::TNormProduct
    assert_equal [1], tnorm.to_cfs

    tnorm = UFuzzyConvert::TNorm.from_fis("algebraic_product")
    assert tnorm.is_a? UFuzzyConvert::TNormProduct
    assert_equal [1], tnorm.to_cfs

    tnorm = UFuzzyConvert::TNorm.from_fis("bounded_difference")
    assert tnorm.is_a? UFuzzyConvert::TNormBoundedDifference
    assert_equal [2], tnorm.to_cfs

    tnorm = UFuzzyConvert::TNorm.from_fis("drastic_product")
    assert tnorm.is_a? UFuzzyConvert::TNormDrasticProduct
    assert_equal [3], tnorm.to_cfs

    tnorm = UFuzzyConvert::TNorm.from_fis("einstein_product")
    assert tnorm.is_a? UFuzzyConvert::TNormEinsteinProduct
    assert_equal [4], tnorm.to_cfs

    tnorm = UFuzzyConvert::TNorm.from_fis("hamacher_product")
    assert tnorm.is_a? UFuzzyConvert::TNormHamacherProduct
    assert_equal [5], tnorm.to_cfs
  end

end
