require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/exporter'
include Mocha::API


class TxtExporterTest < Test::Unit::TestCase

  def test_export_success
    output_mock = StringIO.new

    StringIO
      .expects(:open)
      .with('output.txt', 'w')
      .yields(output_mock)

    UFuzzyConvert::Exporter::TxtExporter.export(
      [*0..11], "output.txt", StringIO
    )

    expected_output = <<EOS
0x00u, 0x01u, 0x02u, 0x03u, 0x04u, 0x05u, 0x06u, 0x07u, 0x08u, 0x09u, 0x0au,
0x0bu
EOS
    expected_output.chomp!

    assert_equal expected_output, output_mock.string
    StringIO.unstub(:open)
  end

  def test_export_success_with_different_destination
    output_mock = StringIO.new
    StringIO
      .expects(:open)
      .with('destination/output', 'w')
      .yields(output_mock)

    UFuzzyConvert::Exporter::TxtExporter.export(
      [*0..11], "destination/output", StringIO
    )

    assert (not output_mock.string.empty?)
    StringIO.unstub(:open)
  end

  def test_export_success_eol
    output_mock = StringIO.new
    StringIO
      .expects(:open)
      .with('output.txt', 'w')
      .yields(output_mock)

    UFuzzyConvert::Exporter::TxtExporter.export(
      [*0..10], "output.txt", StringIO
    )

    expected_output = <<EOS
0x00u, 0x01u, 0x02u, 0x03u, 0x04u, 0x05u, 0x06u, 0x07u, 0x08u, 0x09u, 0x0au
EOS
    expected_output.chomp!

    assert_equal expected_output, output_mock.string
    StringIO.unstub(:open)
  end
end
