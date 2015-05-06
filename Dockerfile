FROM ruby:2.1.5

Maintainer Matthew Rose

RUN apt-get update
RUN apt-get install -y libpq-dev qt5-default libqt5webkit5-dev

# add nodejs
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# bundle gems
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /rails/slowmonster

# git is used by npm/bower
run apt-get install -y git

WORKDIR /rails/slowmonster
RUN mv .git .git.bak
RUN npm install --unsafe-perm
RUN mv .git.bak .git

RUN cp config/interim_database.yml config/database.yml
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
RUN cp config/actual_database.yml config/database.yml

CMD bundle exec unicorn_rails -E production -c /rails/slowmonster/config/unicorn.rb
