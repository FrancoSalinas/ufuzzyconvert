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
    output_mock = {
      'output.c' => StringIO.new,
      'output.h' => StringIO.new
    }

    open_mock = lambda {|path, *args, &block| block.call(output_mock[path])}

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..11], "output.c", open_mock
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
      output_mock['output.c'].string.include?(partial_source),
      "Expected #{output_mock['output.c'].string} to contain #{partial_source}"
    )

    assert(
      output_mock['output.h'].string.include?(partial_header),
      "Expected #{output_mock['output.h'].string} to contain #{partial_header}"
    )
  end

  def test_export_success_with_different_destination
    output_mock = {
      'directory/output.c' => StringIO.new,
      'directory/output.h' => StringIO.new
    }

    open_mock = lambda {|path, *args, &block| block.call(output_mock[path])}

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..11], "directory/output", open_mock
    )

    assert (not output_mock['directory/output.c'].string.empty?)

    assert (not output_mock['directory/output.h'].string.empty?)
  end

  def test_export_success_eol
    output_mock = {
      'output.c' => StringIO.new,
      'output.h' => StringIO.new
    }

    open_mock = lambda {|path, *args, &block| block.call(output_mock[path])}

    UFuzzyConvert::Exporter::CExporter.export(
      [*0..10], "output", open_mock
    )

    partial_source = <<EOS
const uint8_t OUTPUT[] = {
    0x00u, 0x01u, 0x02u, 0x03u, 0x04u, 0x05u, 0x06u, 0x07u, 0x08u, 0x09u, 0x0au
};
EOS

    assert(
      output_mock['output.c'].string.include?(partial_source),
      "Expected #{output_mock['output.c'].string} to contain #{partial_source}"
    )
  end
end
