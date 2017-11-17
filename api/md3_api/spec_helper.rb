# File Loads
require 'byebug'
require_relative '../../database/database.rb'
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/http/*.rb') { |file| require_relative file }

# Create a database connection
Db.connect

# This is boilerplate rspec configuration
RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
end
