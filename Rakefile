require 'require_all'

task default: [:all]

task :lint do
  rubocop api application database
end

task :load_all do
  require_all 'apis'
  require_all 'applications'
  require_rel 'databases/database.rb'
end

task :metaldesk do
  Rake::Task[:lint].execute
  Rake::Task[:load_all].execute
  puts 'hurray'
end

task :all do
  Rake::Task[:metaldesk].execute
end
