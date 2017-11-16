require 'rubygems'

task default: [:all]

task :metaldesk do
  sh 'rubocop application database'
  puts 'hurray'
end

task :apis do
  sh 'rubocop api database'
  sh 'rspec api'
end

task :all do
  puts 'Execution API Tests'
  Rake::Task[:apis].execute
  puts 'Executing MetalDesk Tests'
  Rake::Task[:metaldesk].execute
end
