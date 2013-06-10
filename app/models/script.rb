class Script

  def self.base_dir
    @@base_dir ||= Rails.root.join('scripts')
  end

  def self.list
    Dir.entries(Script.base_dir).reject { |f| f.match(/^\./) }
  end

  def initialize(name)
    @filename = name
    @file = File.join(Script.base_dir, name)
  end

  def filename
    @filename
  end

  def type
    @type ||= if filename.ends_with? '.coffee'
      'coffeescript'
    elsif filename.ends_with? '.js'
      'javascript'
    end
  end

  def read
    File.read(@file)
  end

  def write(content)
    File.open(@file, "w") do |f|
      f.write(content)
    end
  end

  def delete
    File.delete(@file)
  end

end
