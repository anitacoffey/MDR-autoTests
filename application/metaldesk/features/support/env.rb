require 'yaml'
require 'watir'
require 'byebug'

require_relative '../../../../database/database.rb'
run_context = File.dirname(File.absolute_path(__FILE__))
Dir.glob(run_context + '/../../../../helpers/**/*.rb') { |file| require_relative file }
Dir.glob(run_context + '../step_definitions/**/*.rb') { |file| require_relative file }
Dir.glob(run_context + '../pages/**/*.rb') { |file| require_relative file }
Dir.glob(run_context + '../hooks/**/*.rb') { |file| require_relative file }

# Create a database connection
Db.connect

ENV['TEST_ENV'] ||= 'local'
ENV['BROWSER'] ||= 'chrome'
url = YAML.load_file(run_context + '/../../../../config/config.yml')[ENV['TEST_ENV']]['url']
Watir.default_timeout = 10

# This is run before every test case, so this is where we can reset the DB
Before do |scenario|
  MysqlReset.reset_all_users_to_australia

  feature_name = scenario.scenario_outline.feature.name.to_s
  example_row = scenario.scenario_outline.cell_values.to_s
  example_name = example_row.split('"').map(&:to_s)
  puts "Running Scenario: #{feature_name} Testing for: #{example_name[1]}"

  # This is the global browser object
  $browser = ENV['HEADLESS'] ? Watir::Browser.new(:chrome, headless: true) : Watir::Browser.new(:chrome)
  $browser.goto(url)
  $browser.window.resize_to 1920, 1200
end

After do |scenario|
  puts scenario.exception.message.to_s if scenario.failed?
  $browser.quit
end
