# frozen_string_literal: true

require 'appraisal'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end

task default: :appraisal if !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS']
