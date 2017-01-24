require 'simplecov'
SimpleCov.start

Dir.glob("test/**/*.rb") { |f| require_relative("../" + f) }
