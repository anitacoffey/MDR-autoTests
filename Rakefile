require 'rubygems'

task default: [:all]

task :metaldesk do
  sh 'rubocop application database'
  puts 'hurray'
end

task :md3api do
  sh 'rubocop api database'
  sh 'cd api && rspec md3_api'
end

task :all do
  puts 'Execution API Tests'
  Rake::Task[:md3api].execute
  puts 'Executing MetalDesk Tests'
  Rake::Task[:metaldesk].execute
end
