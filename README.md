Hubot Control
=============

Control self-hosted Hubot like a boss!

## Installation

- Run it like a regular Rails 4 app, i.e. with `rails s`, or deploy with Unicorn, Thin or Passenger
- Owner of rails app process must have write permissions to `#{Rails.root}/hubots`
- It has no authorization mechanism yet, so make sure the URL is not accessible for public

## Usage

1. Check status page and install missing dependencies for Hubot
2. Add hubot instance
3. Configure the variables, add scripts
4. Click on Hubot name in the sidebar to control it

## Disclaimer

This project is in early beta stage, install and use at your own risk.

## Features

### Check server compatibility
![Hubot Check Prerequisites](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-5.png)

### Create Hubot instances from web interface
![Create Hubot](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-3.png)

### Test your Hubot via interactive web shell
![Test Hubot](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-6.png)

### Control your Hubot
![Hubot Control Panel](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-1.png)

### Edit Variables and configuration files
![Hubot Configuration](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-2.png)

### Tail logs to troubleshoot problems
![Hubot Log](https://dl.dropboxusercontent.com/u/176100/hubot-control/hubot-control-5.png)

## TODO

  - Auto-install adapter dependencies
  - Configuration templates
  - Script development toolkit

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
