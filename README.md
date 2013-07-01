Hubot Control
=============

Control self-hosted Hubot like a boss!

## Installation

- Run DB migrations with `rake db:migrate` 
- Run it like a regular Rails 4 app. Try it out with `rails s`, run daemonized with `unicorn_rails -p <port> -D`.
- Owner of rails app process must have write permissions to `#{Rails.root}/hubots` and `#{Rails.root}/scripts`, or just `#{Rails.root}`
- It has no authorization mechanism yet, so make sure the URL is not accessible for public

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
