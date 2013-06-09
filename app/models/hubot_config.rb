class HubotConfig

  def self.valid_json?(json)
    JSON.parse(json)
    true
  rescue
    puts "INVALID!"
    false
  end

  def initialize(hubot)
    @hubot = hubot
  end

  def variables
    JSON.pretty_generate(@hubot.variables || {})
  end

  def variables=(vars)
    @hubot.variables = JSON.parse vars
    @hubot.save
  end

  def package
    read_file 'package.json'
  end

  def package=(content)
    write_file 'package.json', content
  end

  def hubot_scripts
    read_file 'hubot-scripts.json'
  end

  def hubot_scripts=(content)
    write_file 'hubot-scripts.json', content
  end

  def external_scripts
    read_file 'external-scripts.json'
  end

  def external_scripts=(content)
    write_file 'external-scripts.json', content
  end

  private

    def read_file(file)
      File.read(File.join(@hubot.location, file))
    end

    def write_file(file, content)
      File.open(File.join(@hubot.location, file), 'w') do |f|
        f.write(content)
      end
    end
end
