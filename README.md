Hubot Control
=============

Control self-hosted Hubot like a boss!

[![Build Status](https://travis-ci.org/spajus/hubot-control.png?branch=master)](https://travis-ci.org/spajus/hubot-control)
[![Coverage Status](https://coveralls.io/repos/spajus/hubot-control/badge.png?branch=master)](https://coveralls.io/r/spajus/hubot-control?branch=master)
[![Code Climate](https://codeclimate.com/github/spajus/hubot-control.png?branch=master)](https://codeclimate.com/github/spajus/hubot-control)
[![Dependency Status](https://gemnasium.com/spajus/hubot-control.png?branch=master)](https://gemnasium.com/spajus/hubot-control)

## Installation

- Run DB migrations with `rake db:migrate`
- Change `config.action_mailer.default_url_options` in `config/environments/*` (optional)
- Run it like a regular Rails 4 app. Try it out with `rails s`, run daemonized with `unicorn_rails -p <port> -D`.
- Owner of rails app process must have write permissions to `#{Rails.root}/hubots` and `#{Rails.root}/scripts`, or just `#{Rails.root}`
- Use `admin@hubot-control.org` / `hubot` to log in

## Tutorials

[How to get Hubot on HipChat using Hubot Control on CentOS Linux](http://varaneckas.com/blog/hubot-hipchat-centos/)

## Book: Automation and Monitoring with Hubot

[Automation and Monitoring with Hubot](https://leanpub.com/automation-and-monitoring-with-hubot) is already available at Leanpub.

## Running on Heroku

```
git clone git@github.com:spajus/hubot-control.git && cd hubot-control
heroku create --buildpack https://github.com/rtgibbons/heroku-buildpack-ruby-nodejs.git
git push heroku master
heroku config:add PATH=/app/node_modules/.bin:/app/bin:/app/vendor/bundle/ruby/2.0.0/bin:/usr/local/bin:/usr/bin:/bin
heroku run rake db:migrate
heroku open
```

Heroku support is still experimental, but you can find some [helpful tips here](https://github.com/spajus/hubot-control/pull/2).

Heroku demo: http://hubot-control-demo.herokuapp.com/ (usually broken due to periodic file system wipeouts, see [issues/4](https://github.com/spajus/hubot-control/issues/4))

## Running with Docker

Prerequisites:

* [Docker](https://docker.com)

Start a Postgres instance

    docker run --name hubot-control-db -d -e USER="docker" -e DB="hubot_control" -e PASS="docker" paintedfox/postgresql

Create a data-only container to store Hubots

    docker run --name hubot-control-data -v /usr/src/hubot-control/hubots busybox

Run database migrations

    docker run --rm --link hubot-control-db:db -e RAILS_DB_USERNAME="docker" -e RAILS_DB_PASSWORD="docker" hackedu/hubot-control bundle exec rake db:migrate RAILS_ENV=production

Start Hubot Control

    docker run --name hubot-control -d --link hubot-control-db:db --volumes-from hubot-control-data -e RAILS_DB_USERNAME="docker" -e RAILS_DB_PASSWORD="docker" -p 3000:3000 hackedu/hubot-control

Hubot Control will now be running on port 3000 of your system. Whenever you
create a hubot , you'll want to restart Hubot Control and publish their HTTP
ports (`-p` flag).

There's a few things to notice:

* The Postgres database is in a separate container than Hubot Control. When
  Hubot Control is stopped or removed, the database will be persisted in the
  Postgres container. You may want to map the Postgres data to a volume on your
  host. The Postgres image's documentation has more details on this
  (https://registry.hub.docker.com/u/paintedfox/postgresql/).
* The files for created hubots are stored in the `hubot-control-data`
  container. Do not delete this container unless you want to delete all of your
  hubots. 
* All of the application data for Hubot Control is stored in separate
  containers, so we don't lose any data if we delete the `hubot-control`
  container.

## Usage

1. Check status page and install missing dependencies for Hubot
2. Add hubot instance
3. Configure the variables, add scripts
4. Click on Hubot name in the sidebar to control it
5. Develop scripts with built-in editor

## Features

### Check server compatibility
![Hubot Check Prerequisites](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/status.png)

### Create Hubot instances from web interface
![Create Hubot](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/build.png)

### Test your Hubot via interactive web shell
![Test Hubot](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/shell.png)

### Control your Hubot
![Hubot Control Panel](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/hubot-status.png)

### Edit pre-startup script
![Hubot before start](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/before-start.png)

### Manage and develop custom Hubot scripts
![Hubot Scripts](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/scripts.png)
![Edit Hubot Scripts](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/edit-script.png)
![Include External Scripts](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/external-scripts.png)

### Edit variables and configuration files
![Hubot Configuration](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/variables.png)

### Tail logs to troubleshoot problems
![Hubot Log](https://dl.dropboxusercontent.com/u/176100/hubot-control/screens/log.png)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
