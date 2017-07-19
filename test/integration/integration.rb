#!/usr/bin/env ruby

require 'rubygems'
require 'ufuzzyconvert/fuzzy_system'

def run()
  verbose = ARGV[1] == '-v'
  tests = 0
  failed = 0
  Dir.glob('./fis/**/*.fis') do |fis_file|
    tests += 1

    print "Parsing #{fis_file}."

    # Read the FIS file.
    contents = read_file(fis_file)

    begin
      UFuzzyConvert::FuzzySystem.from_fis(contents).to_cfs
      puts " Success."
    rescue UFuzzyConvert::UFuzzyError => e
      puts " Failure."
      puts e.message
      if verbose then puts e.backtrace end
      puts ""

      failed += 1
    end
  end

  puts "#{tests} tests. #{failed} failed."
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

run()
