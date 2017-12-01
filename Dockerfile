FROM ruby:2.3.0

# Chrome install
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list
RUN wget https://dl.google.com/linux/linux_signing_key.pub
RUN apt-key add linux_signing_key.pub

# Dependencies
RUN apt-get update
RUN apt-get install -y libmysqlclient-dev libpq-dev unzip libnss3-dev libgconf-2-4 google-chrome-stable

# Chromedriver install
RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver

# Add the code
ADD . /testing
WORKDIR /testing

# Ruby dependency installs
RUN gem install bundler
RUN bundle install

# Run the tests
CMD HEADLESS=true rake
