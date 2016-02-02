FROM phusion/baseimage

Maintainer Matthew Rose

RUN apt-get update
RUN apt-get install -y libpq-dev qt5-default libqt5webkit5-dev git libreadline-dev sqlite3 libsqlite3-dev

# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh

# install ruby-build
RUN mkdir /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv

ENV PATH "$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# does not work. PATH is set to
# $RBENV_ROOT/shims:$RBENV_ROOT/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install ruby2
RUN rbenv install 2.1.5
ENV RBENV_VERSION 2.1.5

# add nodejs
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# bundle gems
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler zeus
RUN bundle install

ADD . /rails/slowmonster

# git is used by npm/bower
run apt-get install -y git

WORKDIR /rails/slowmonster
# need to temporarily move the .git file (which is a pointer to a dir that doesn't exist in the container)
RUN mv .git .git.bak
RUN npm install --unsafe-perm
RUN mv .git.bak .git

RUN cp config/interim_database.yml config/database.yml
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
RUN cp config/actual_database.yml config/database.yml

CMD bundle exec unicorn_rails -E production -c /rails/slowmonster/config/unicorn.rb
