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

  def before_start_exists?
     File.exist? path_to('before_start.sh')
  end

  def before_start
    if before_start_exists?
      read_file 'before_start.sh'
    else
      Script::BEFORE_START_TEMPLATE
    end
  end

  def before_start=(content)
    write_file 'before_start.sh', content
    system "chmod a+x #{path_to('before_start.sh')}"
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

    def path_to(file)
      File.join(@hubot.location, file)
    end

    def read_file(file)
      File.read(path_to(file))
    end

    def write_file(file, content)
      File.open(path_to(file), 'wb') do |f|
        f.write(content.split("\n").map(&:rstrip).join("\n"))
      end
    end
end
