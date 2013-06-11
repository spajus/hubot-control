class Script

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
    msg.send "jumping!"

  robot.hear /your'e/i, (msg) ->
    msg.send "you're"

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
    msg.send("jumping!");
  });

  robot.hear(/your'e/i, function(msg) {
    msg.send("you're");
  });

  robot.router.get("/foo", function(req, res) {
    res.end("bar");
  });
}
END

  def self.base_dir
    @@base_dir ||= Rails.root.join('scripts')
  end

  def self.list
    Dir.entries(Script.base_dir).reject { |f| f.match(/^\./) }
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
