FROM ruby:3.1.4
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  zip \
  nodejs \
  postgresql-contrib

RUN mkdir -p /app 
WORKDIR /app

ADD Gemfile* /app/
RUN gem install bundler --pre
RUN bundle install

ADD . /app
