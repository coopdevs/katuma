FROM ruby:2.1.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN curl -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install -y nodejs

RUN gem install bundler
RUN gem cleanup bundler

ENV APP_HOME /katuma
RUN mkdir /katuma
WORKDIR $APP_HOME

# Unlike most Dockerfiles, as the Gemfile depends on the $APP_HOME/engines
# folder, we can't run bundle install before copying the files from the host
# machine
ADD . $APP_HOME
RUN bundle install
