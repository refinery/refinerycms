FROM ruby:2.6-alpine

RUN apk add --no-cache git g++
RUN apk add --no-cache tzdata

# for sqlite
RUN apk add --no-cache sqlite-dev

# for mysql
RUN apk add --no-cache mysql-dev

# for postgres
RUN apk add --no-cache postgresql-dev postgresql-client

# for assets
RUN apk add --no-cache nodejs

RUN apk add --no-cache imagemagick

# for nokogiri
RUN apk add --no-cache --virtual .ruby-gemdeps libc-dev gcc libxml2-dev libxslt-dev make

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN unset BUNDLE_PATH
RUN unset BUNDLE_BIN

ENV BUNDLE_JOBS 4

ENV APP_HOME /refinery
WORKDIR $APP_HOME

ENV RAILS_ENV=test

RUN gem install bundler --version ">= 2.0.2"
