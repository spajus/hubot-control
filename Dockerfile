# Hubot Control

FROM ubuntu:13.10

# install dependencies
RUN apt-get update && apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libpq-dev nodejs nodejs-legacy npm
RUN npm install -g coffee-script
RUN npm install -g hubot

# install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git /usr/local/rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build
RUN echo '# rbenv setup' > /etc/profile.d/rbenv.sh
RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
RUN echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
RUN chmod +x /etc/profile.d/rbenv.sh
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install ruby 2.0
RUN rbenv install 2.0.0-p451
RUN rbenv global 2.0.0-p451

# skip installing documentation
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc

RUN gem install bundler && rbenv rehash

ADD . /usr/src/hubot-control
WORKDIR /usr/src/hubot-control

RUN bundle install --system && rbenv rehash

RUN RAILS_ENV=production bundle exec rake assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "unicorn", "-p", "3000", "-c", "./config/unicorn.rb", "-E", "production"]
