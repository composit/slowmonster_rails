FROM ubuntu:14.04

Maintainer Matthew Rose

RUN apt-get update

# Install Ruby
RUN apt-get install -y wget build-essential
RUN wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz
RUN tar -xzvf ruby-install-0.4.3.tar.gz
RUN cd ruby-install-0.4.3/ && make install
RUN ruby-install ruby 2.1.5
ENV PATH $PATH:/opt/rubies/ruby-2.1.5/bin/

RUN gem install bundler

# ADD a user
# TODO add password?
RUN adduser --disabled-password --home=/rails --gecos "" rails

# gem dependencies
RUN apt-get install -y libpq-dev # pg

# development dependencies
# RUN apt-get install -y libqtwebkit-dev # capybara-webkit
RUN apt-get install -y sqlite3 libsqlite3-dev # sqlite

# add nodejs
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

RUN chown -R rails:rails /tmp

USER root
ADD code /rails/slowmonster
RUN mkdir -p /rails/slowmonster/tmp/sockets/slowmonster
RUN chown -R rails:rails /rails/slowmonster

ADD drunkship_files/application.yml /rails/slowmonster/config/application.yml
ADD drunkship_files/interim_database.yml /rails/slowmonster/config/database.yml
ADD drunkship_files/unicorn.rb /rails/slowmonster/config/unicorn.rb

# install npm?
# install bower?

# git is used by npm/bower
run apt-get install -y git

USER rails
WORKDIR /rails/slowmonster
RUN npm install
RUN bundle install --binstubs --deployment --without test development
RUN bundle exec rake assets:precompile
ADD drunkship_files/database.yml /rails/slowmonster/config/database.yml

CMD bundle exec unicorn_rails -E production -c /rails/slowmonster/config/unicorn.rb
