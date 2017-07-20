require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/defuzzifier'
include Mocha::API


class DefuzzifierTest < Test::Unit::TestCase
  def test_from_fis_unrecognized_name
    assert_raise(
      UFuzzyConvert::FeatureError.new "'asd' defuzzifier not recognized."
    ) do
      UFuzzyConvert::Defuzzifier.from_fis("asd")
    end
  end

  def test_from_fis_success
    tnorm = UFuzzyConvert::Defuzzifier.from_fis("centroid")
    assert tnorm.is_a? UFuzzyConvert::Centroid
    assert_equal [0], tnorm.to_cfs
  end

end
