require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/exporter'
include Mocha::API


class ExporterTest < Test::Unit::TestCase
  def test_export_format_not_supported
    assert_raise(
      UFuzzyConvert::FeatureError.new "Format xml not supported."
    ) do
      UFuzzyConvert::Exporter.export([0x00, 0x01], "xml", "output.xml")
    end
  end

  def test_export_success
    UFuzzyConvert::Exporter::TxtExporter
      .expects(:export)

    UFuzzyConvert::Exporter.export([0x00, 0x01], "txt", "output.txt")

    UFuzzyConvert::Exporter::TxtExporter.unstub(:export)
  end
end
