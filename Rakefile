# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "delphix_rb"
  gem.homepage = "http://github.com/mickuehl/delphix_rb"
  gem.license = "MIT"
  gem.summary = %Q{Delphix Engine REST API client in Ruby}
  gem.description = %Q{Delphix Engine REST API}
  gem.email = "michael.kuehl@delphix.com"
  gem.authors = ["Michael Kuehl"]
  
  # exclude tests and examples
  gem.files.exclude 'examples/*'
  gem.files.exclude 'test/*'
  
  # dependencies defined in Gemfile
  gem.add_dependency 'excon', '~> 0.45.4'
  
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "delphix_rb #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
