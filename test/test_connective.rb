require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/connective'
include Mocha::API


class ConnectiveTest < Test::Unit::TestCase

  def test_from_fis_type_not_supported
    and_operator_mock = mock('and_operator_mock')
    or_operator_mock = mock('or_operator_mock')

    assert_raise_with_message(
      UFuzzyConvert::FeatureError,
      "Connective type 3 not supported."
    ) do
      UFuzzyConvert::Connective.from_fis_data(
        and_operator_mock, or_operator_mock, 3
        )
    end
  end

  def test_from_fis_success
    and_operator_mock = mock('and_operator_mock')
    or_operator_mock = mock('or_operator_mock')

    assert_equal(
      and_operator_mock,
      UFuzzyConvert::Connective.from_fis_data(
        and_operator_mock, or_operator_mock, 1
      )
    )

    assert_equal(
      or_operator_mock,
      UFuzzyConvert::Connective.from_fis_data(
        and_operator_mock, or_operator_mock, 2
      )
    )
  end
end
