require 'rake'

require 'rake/testtask'
require 'rspec/core/rake_task'
require 'generative/rake_task'

task(:default).enhance [:spec, :generative]

Rake::TestTask.new
RSpec::Core::RakeTask.new
Generative::RakeTask.new
