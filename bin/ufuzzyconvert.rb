require_relative '../lib/fis_parser'
require_relative '../lib/fuzzy_system'
require 'pp'

puts File.basename(Dir.getwd)

if not ARGV.first
  puts "Usage: ufuzzyconvert.rb file"
  exit 0
end

begin
  file = File.open(ARGV.first, "r")
rescue
  puts "Could not open #{ARGV.first} file."
  exit 0
end

begin
  fis = file.read
rescue
  puts "Could not read #{ARGV.first} file."
  exit 0
ensure
  file.close
end

fuzzy_system = UFuzzyConvert::FuzzySystem.from_fis(fis)

File.open('output.cfs', 'wb') do |output|
     fuzzy_system.to_cfs.each do |byte|
          output.print byte.chr
     end
end
