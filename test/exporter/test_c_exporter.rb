require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/exporter'
include Mocha::API


class CExporterTest < Test::Unit::TestCase

  def test_export_success
    source_mock = StringIO.new
    header_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('output.h', 'w')
      .yields(header_mock)

    StringIO
      .expects(:open)
      .with('output.c', 'w')
      .yields(source_mock)

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..11], "output.c", StringIO
    )

    partial_source = <<EOS
const uint8_t OUTPUT[] = {
    0x00u, 0x01u, 0x02u, 0x03u, 0x04u, 0x05u, 0x06u, 0x07u, 0x08u, 0x09u, 0x0au,
    0x0bu
};
EOS

    partial_header = <<EOS
extern const uint8_t OUTPUT[12];
EOS

    assert(
      source_mock.string.include?(partial_source),
      "Expected source file to contain #{partial_source}"
    )

    assert(
      header_mock.string.include?(partial_header),
      "Expected header file to contain #{partial_header}"
    )

    StringIO.unstub(:open)
  end

  def test_export_success_with_different_destination
    source_mock = StringIO.new
    header_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('directory/output.h', 'w')
      .yields(header_mock)

    StringIO
      .expects(:open)
      .with('directory/output.c', 'w')
      .yields(source_mock)

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..11], "directory/output", StringIO
    )

    assert (not source_mock.string.empty?), "Nothing was written to source file."
    assert (not header_mock.string.empty?), "Nothing was written to header file."

    StringIO.unstub(:open)
  end

  def test_export_success_eol
    source_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('output.h', 'w')
      .yields(StringIO.new)

    StringIO
      .expects(:open)
      .with('output.c', 'w')
      .yields(source_mock)

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..10], "output", StringIO
    )

    partial_source = <<EOS
const uint8_t OUTPUT[] = {
    0x00u, 0x01u, 0x02u, 0x03u, 0x04u, 0x05u, 0x06u, 0x07u, 0x08u, 0x09u, 0x0au
};
EOS

    assert(
      source_mock.string.include?(partial_source),
      "Expected source file to contain #{partial_source}"
    )

    StringIO.unstub(:open)
  end
end
