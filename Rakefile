require 'rake'
require 'rake/testtask'
require_relative  'test/test_note'

task :test_note => :environment do
	tn = TestNote.new
	tn.test_note
end

task :default => :test_note


