FROM circleci/ruby:2.6-buster-node-browsers

RUN sudo mkdir -p refinerycms && sudo chown -R $(whoami) refinerycms
RUN git clone https://github.com/refinery/refinerycms /refinerycms

ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
RUN unset BUNDLE_PATH
RUN unset BUNDLE_BIN
ENV RAILS_ENV=test

RUN gem install bundler --version ">= 2.0.2"
RUN BUNDLE_JOBS=16 BUNDLE_GEMFILE=/refinerycms/Gemfile bundle install --without development

RUN sudo rm -rf /refinerycms

CMD ["/bin/sh"]
