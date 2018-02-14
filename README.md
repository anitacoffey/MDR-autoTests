# md3-testing
Application and API tests for the MD3 Stack

## Getting Started
Install ruby v2.3. Rbenv is the preferable installation mechanism (https://github.com/rbenv/rbenv).

Run `rbenv install` in this folder (uses a .ruby-version file to manage the versions)

Ensure the correct ruby version is in the environment by calling `rbenv global 2.3.0`. This lets you use all the ruby executables (gem, bundle and ruby itself).

Run `gem install bundler`

Run `bundle install`
 * Some system dependencies will be required. i.e. Mysql and Postgres client libraries.
 * A failed bundle install should prompt the requirements

Ensure your PATH is extended to the correct ruby gem location in ~/.bash_profile by appending the following line (this is unnecessary if you've installed ruby through rbenv and run the `global` command
`export PATH="/home/sam/.rbenv/versions/2.3.0/bin:$PATH"`

Once ruby is installed, you will need to install docker to be able to run the exchange with the `orc` repository.

Then install the chromedriver by running `sh install_chromedriver.sh`

## Running All the Tests

Run `rake`

The tests are divided into two categories. API tests and application tests.

API tests directly hit our APIs and validate the payload and underlying database.

The application tests are end-to-end tests the use Cucumber and the Watir webdriver to test our applications.

Rubocop is used to enforce consistent code styling. The specs will not run if the linter fails.

When new test suites are added, they should be added to the Rakefile.

## Headless testing
The tests can easily be run headlessly by providing the HEADLESS=true ENV var to either the rake command or cucumber directly.

## Rubocop

Rubcop can be run manually to get a better stack trace by running `rubocop`.

It can auto-correct a number of errors by running `rubocop --auto-correct`

## Application Tests
Within the application folder, a number of cucumber projects exist.

To create a new one, make a new directory within application, i.e. application/new_test_suite. From within the new suites folder, run cucumber --init to get the required initialisation files.

The entry point to a cucumber project is `support/env.rb`. All files should be loaded from here.

To run isolated tests, cd to the desired application test folder and run cucumber --t theTagYouCareAbout

## API Tests
The API tests use rspec to declare the testing scenarios and the `httparty` gem for simple HTTP interactions.

## DB Connections
Active record has been configured in the database folder to allow simple connections to the databases.

## Local Development guide for testers

### Boot local exchange with Orc

Run `docker ps`. If containers are running, follow `turn off` commands

cd orc
git pull
npm i
npm start
local_start

Navigate to local.bullioncapital.com. See if the it loads correctly within ~2 minutes

### Turn off local exchange

cd orc
npm start
local_stop
