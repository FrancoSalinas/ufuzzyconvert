# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ufuzzyconvert/version"

Gem::Specification.new do |spec|
  spec.name          = "ufuzzyconvert"
  spec.version       = Ufuzzyconvert::VERSION
  spec.authors       = ["Franco Javier Salinas Mendoza"]
  spec.email         = ["franco.salinas.mendoza@gmail.com"]

  spec.summary       = "Converts FIS files used by MATLAB to µFuzzy's CFS format."
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/fsalinasmendoza/ufuzzyconvert"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.1'

  spec.add_dependency "treetop"
  spec.add_dependency "trollop"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "mocha", "~>1.2.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov", "~>0.14"
  spec.add_development_dependency "test-unit", "~>3.2"
  spec.add_development_dependency "yard", "~>0.9"
end
