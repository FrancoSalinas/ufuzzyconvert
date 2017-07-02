require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'

task :default => :test

YARD::Templates::Engine.register_template_path 'template'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
end

YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb']
 # t.stats_options = ['--list-undoc']
end
