#!/usr/bin/env ruby

require 'logger'
require 'pp'
require 'trollop'

require_relative '../lib/fis_parser'
require_relative '../lib/fuzzy_system'
require_relative '../lib/exporter'

def run()
  # Parse command line options.
  opts = parse_options(UFuzzyConvert::Exporter.formats)

  # Read the FIS file.
  contents = read_file(opts[:source])

  # Convert the file to CFS format.
  convert(contents, opts[:destination], opts)
end

def parse_options(supported_formats, args=ARGV)
  opts = Trollop::options(args) do
    banner <<-EOS
µFuzzyConvert is a tool for converting FIS files used by MATLAB to CFS format,
a lightweight binary format used by µFuzzy.

Usage:
       ufuzzyconvert [-d dsteps] [-s tsize] [-f format] SOURCE [DESTINATION]

  SOURCE              Specifies the input FIS file.
  DESTINATION         Specifies the output file. If DESTINATION is not
                      defined, the output file is created in the working
                      directory, and receives the same name as the source file
                      with the extension of the selected format.
EOS
    opt(
      :dsteps,
      "Sets the number of defuzzification steps. Maximum is 14 (16384 steps).",
      :default => 8,
      :short => 'd'
    )
    opt(
      :tsize,
      "Sets the size of the membership function tables. Maximum is 14 "\
      "(16384 entries).",
      :default => 8,
      :short => 's'
    )
    opt(
      :format,
      "Selects the output format. Supported formats: #{supported_formats}.",
      :default => 'txt',
      :short => 'f'
    )
  end

  Trollop::die "The source file must be specified" if args.empty?

  Trollop::die :dsteps, "must be non-negative" if opts[:dsteps] < 0
  Trollop::die :tsize, "must be non-negative" if opts[:tsize] < 0

  Trollop::die :format, "not supported" if not supported_formats.include? opts[:format]

  src = args.first
  dest = args.fetch(1, "#{File.basename(src, File.extname(src))}.#{opts[:format]}")

  return {
    :dsteps => opts[:dsteps],
    :tsize => opts[:tsize],
    :format => opts[:format],
    :source => src,
    :destination => dest
  }
end

def read_file(file_name)
  begin
    file = File.open(file_name, "r")
  rescue
    puts "Could not open #{file_name} file."
    exit 0
  end

  begin
    contents = file.read
  rescue
    puts "Could not read #{file_name} file."
    exit 0
  ensure
    file.close
  end

  return contents
end

def convert(contents, destination, opts)
  logger = Logger.new('ufuzzyconvert.log')
  begin
    cfs_data = UFuzzyConvert::FuzzySystem.from_fis(contents).to_cfs(opts)

    UFuzzyConvert::Exporter.export(cfs_data, opts[:format], destination)
  rescue UFuzzyConvert::UFuzzyError => e
    puts e.message

    logger.error "\n  #{e.backtrace.join("\n  ")}\n#{e.message}"
  end
end

if $0 == __FILE__
  run()
end
