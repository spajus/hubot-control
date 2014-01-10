class Script

  BEFORE_START_TEMPLATE = <<-END
#!/bin/bash
#
# This script will be executed before Hubot starts. You may need such a script for more
# complicated adapters, like Skype. Example of Skype startup script for linux:
#
# export DISPLAY="localhost:10"
#
# skype_running=`ps -ef | grep /usr/bin/skype | grep -v grep | wc -l`
#
# if [ "$skype_running" -ne "2" ]; then
#
#   echo "Skype not fully running"
#   echo "Killing stray /usr/bin/skype processes"
#   ps -ef | grep /usr/bin/skype | grep -v grep | awk '{print $2}' | xargs kill -9
#
#   xvfb_running=`ps -ef | grep 'Xvfb :10' | grep -v grep | wc -l`
#   if [ "$xvfb_running" -ne "0" ]; then
#     echo "Xvfb running, killing it"
#     kill -9 `ps -ef | grep 'Xvfb :10' | grep -v grep | awk '{print $2}'`
#   fi;
#
#   echo "Starting skype on Xvfb, display 10"
#   xvfb-run -n 10 -s "-screen 10 800x600x16" /usr/bin/skype &
#   echo "Sleeping 30 seconds while skype starts"
#   sleep 30
#   exit 0
# fi;
#
# echo "Skype seems to be running"
# ps -ef | grep /usr/bin/skype | grep -v grep
END

  COFFEE_TEMPLATE = <<-END
# Description
#   <description of the scripts functionality>
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

module.exports = (robot) ->

  robot.respond /jump/i, (msg) ->
    msg.emote "jumping!"

  robot.hear /your'e/i, (msg) ->
    msg.send "you're"

  robot.hear /what year is it\?/i, (msg) ->
    msg.reply new Date().getFullYear()

  robot.router.get "/foo", (req, res) ->
    res.end "bar"
END

  JS_TEMPLATE = <<-END
// Description
//   <description of the scripts functionality>
//
// Dependencies:
//   "<module name>": "<module version>"
//
// Configuration:
//   LIST_OF_ENV_VARS_TO_SET
//
// Commands:
//   hubot <trigger> - <what the respond trigger does>
//   <trigger> - <what the hear trigger does>
//
// Notes:
//   <optional notes required for the script>
//
// Author:
//   <github username of the original script author>

module.exports = function(robot) {

  robot.respond(/jump/i, function(msg) {
    msg.emote("jumping!");
  });

  robot.hear(/your'e/i, function(msg) {
    msg.send("you're");
  });

  robot.hear(/what year is it\?/i, function(msg) {
    msg.reply(new Date().getFullYear());
  });

  robot.router.get("/foo", function(req, res) {
    res.end("bar");
  });
};
END

  def self.base_dir
    @@base_dir ||= Rails.root.join('scripts')
  end

  def self.list
    return [] unless Dir.exist? Script.base_dir
    Dir.entries(Script.base_dir).reject { |d| d.match(/^\./) }.sort
  end

  def self.list_scripts(hubot)
    scripts_dir = File.join(hubot.location, 'node_modules', 'hubot-scripts', 'src', 'scripts')
    Dir.entries(scripts_dir).reject { |d| d.match(/^\./) }.sort
  end

  def initialize(name)
    self.filename = name
  end

  def filename
    @filename
  end

  def filename=(filename)
    @filename = filename
    @file = File.join(Script.base_dir, filename)
  end

  def type
    @type ||= if filename.ends_with? '.coffee'
      'coffeescript'
    elsif filename.ends_with? '.js'
      'javascript'
    end
  end

  def read
    File.exist?(@file) ? File.read(@file) : template
  end

  def template
    if filename.end_with? ".coffee"
      COFFEE_TEMPLATE.strip
    elsif filename.end_with? ".js"
      JS_TEMPLATE.strip
    end
  end

  def write(content)
    FileUtils.mkdir_p Script.base_dir
    File.open(@file, "w") do |f|
      f.write(content)
    end
  end

  def delete
    File.delete(@file)
  rescue Errno::ENOENT => e
    Rails.logger.warn("Could not delete #{@file}: #{e}")
  end

end
