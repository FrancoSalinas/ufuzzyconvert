require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require 'ufuzzyconvert/exporter'
include Mocha::API


class CfsExporterTest < Test::Unit::TestCase

  def test_export_success
    output_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('output.cfs', 'wb')
      .yields(output_mock)

    UFuzzyConvert::Exporter::CfsExporter.export(
      [*0..11], "output.cfs", StringIO
    )

    assert_equal [*0..11], output_mock.string.bytes

    StringIO.unstub(:open)
  end

  def test_export_success_with_different_destination
    output_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('directory/output.cfs', 'wb')
      .yields(output_mock)

    UFuzzyConvert::Exporter::CfsExporter.export(
      [*0..11], "directory/output.cfs", StringIO
    )

    assert (not output_mock.string.empty?)
    StringIO.unstub(:open)
  end
end
