require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'

task :test => 'test:unit'
task 'test:all' => ['test:unit', 'test:integration']
task :default => :test

YARD::Templates::Engine.register_template_path 'template'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.name = "test:unit"
  t.test_files = FileList['test/unit/**/test*.rb']
  t.verbose = ARGV.any? {|s| s == '-v'}
  t.warning = t.verbose
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.name = "test:integration"
  t.test_files = FileList['test/integration/*.rb']
  t.verbose = ARGV.any? {|s| s == '-v'}
  t.warning = t.verbose
end

YARD::Rake::YardocTask.new do |t|
 t.files   = ['lib/**/*.rb']
 # t.stats_options = ['--list-undoc']
end
