require 'simplecov'
SimpleCov.start

require 'rubygems'
gem 'mocha'
require 'test/unit'
require 'mocha/test_unit'
require './bin/ufuzzyconvert'
include Mocha::API


class RuleTest < Test::Unit::TestCase

  def test_parse_options_empty_argv
    assert_raise SystemExit do
      parse_options(["txt", "cfs", "c"], [])
    end
  end

  def test_parse_options_negative_dsteps
    assert_raise SystemExit do
      parse_options(
        ["txt", "cfs", "c"], ["example.fis", "-d", "-1"]
      )
    end
  end

  def test_parse_options_negative_tsize
    assert_raise SystemExit do
      parse_options(
        ["txt", "cfs", "c"], ["example.fis", "-s", "-1"]
      )
    end
  end

  def test_parse_options_txt_format_is_unknown
    assert_raise SystemExit do
      parse_options(
        [], ["example.fis"]
      )
    end
  end

  def test_parse_options_unknown_format
    assert_raise SystemExit do
      parse_options(
        ["txt"], ["example.fis", "-f", "xml"]
      )
    end
  end

  def test_parse_options_source_only
    options = parse_options(
      ["txt"], ["example.fis"]
    )

    assert_equal "example.fis", options[:source]
    assert_equal "example.txt", options[:destination]
    assert_equal "txt", options[:format]
    assert_equal 8, options[:tsize]
    assert_equal 8, options[:dsteps]
  end

  def test_parse_options_source_without_extension
    options = parse_options(
      ["txt"], ["example"]
    )

    assert_equal "example", options[:source]
    assert_equal "example.txt", options[:destination]
    assert_equal "txt", options[:format]
  end

  def test_parse_options_source_in_different_directory
    options = parse_options(
      ["txt"], ["directory/example.fis"]
    )

    assert_equal "directory/example.fis", options[:source]
    assert_equal "example.txt", options[:destination]
    assert_equal "txt", options[:format]
  end

  def test_parse_options_with_destination
    options = parse_options(
      ["txt"], ["directory/example.fis", "directory/output.txt"]
    )

    assert_equal "directory/example.fis", options[:source]
    assert_equal "directory/output.txt", options[:destination]
    assert_equal "txt", options[:format]
  end

  def test_parse_options_custom_args
    options = parse_options(
      ["txt", "cfs"],
      [
        "example.fis",
        "-s", "4",
        "-d", "6",
        "-f", "cfs"
      ]
    )

    assert_equal "example.fis", options[:source]
    assert_equal "example.cfs", options[:destination]
    assert_equal "cfs", options[:format]
    assert_equal 4, options[:tsize]
    assert_equal 6, options[:dsteps]
  end
end
