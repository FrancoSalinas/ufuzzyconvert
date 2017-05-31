require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './lib/exporter'
include Mocha::API


class CfsExporterTest < Test::Unit::TestCase

  def test_export_success
    output_mock = StringIO.new
    open_mock = lambda {|*args, &block| block.call(output_mock)}

    UFuzzyConvert::Exporter::CfsExporter.export(
      [*0..11], "output.cfs", open_mock
    )

    assert_equal [*0..11], output_mock.string.bytes
  end

  def test_export_success_with_different_destination
    output_mock = {
      'directory/output.cfs' => StringIO.new
    }

    open_mock = lambda {|path, *args, &block| block.call(output_mock[path])}

    UFuzzyConvert::Exporter::CfsExporter.export(
      [*0..11], "directory/output.cfs", open_mock
    )

    assert (not output_mock['directory/output.cfs'].string.empty?)
  end
end
