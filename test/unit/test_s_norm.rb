require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/s_norm'
include Mocha::API


class SNormTest < Test::Unit::TestCase
  def test_from_fis_unrecognized_name
    assert_raise(
      UFuzzyConvert::FeatureError.new "'asd' s-norm not recognized."
    ) do
      UFuzzyConvert::SNorm.from_fis("asd")
    end
  end

  def test_from_fis_success
    snorm = UFuzzyConvert::SNorm.from_fis("max")
    assert snorm.is_a? UFuzzyConvert::SNormMaximum
    assert_equal [0],snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("sum")
    assert snorm.is_a? UFuzzyConvert::SNormSum
    assert_equal [1], snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("algebraic_sum")
    assert snorm.is_a? UFuzzyConvert::SNormSum
    assert_equal [1], snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("bounded_sum")
    assert snorm.is_a? UFuzzyConvert::SNormBoundedSum
    assert_equal [2], snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("drastic_sum")
    assert snorm.is_a? UFuzzyConvert::SNormDrasticSum
    assert_equal [3], snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("einstein_sum")
    assert snorm.is_a? UFuzzyConvert::SNormEinsteinSum
    assert_equal [4], snorm.to_cfs

    snorm = UFuzzyConvert::SNorm.from_fis("hamacher_sum")
    assert snorm.is_a? UFuzzyConvert::SNormHamacherSum
    assert_equal [5], snorm.to_cfs
  end

end
