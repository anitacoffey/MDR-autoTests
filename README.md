# md3-testing
Application and API tests for the MD3 Stack

## Getting Started
Install ruby v2.3. Rbenv is the preferable installation mechanism (https://github.com/rbenv/rbenv).

Run `gem install bundler`

Run `bundle install`
 * Some system dependencies will be required. i.e. Mysql and Postgres client libraries.
 * A failed bundle install should prompt the requirements

Ensure your PATH is extended to the correct ruby gem location in ~/.bash_profile by appending the following line
`export PATH="/home/sam/.rbenv/versions/2.3.0/bin:$PATH"`

## Running the tests

Run `rake test`

The tests are divided into two categories. API tests and application tests.

API tests directly hit our APIs and validate the payload and underlying database.

The application tests are end-to-end tests the use Cucumber and the Watir webdriver to test our applications.

Rubocop is used to enforce consistent code styling. The specs will not run if the linter fails.
