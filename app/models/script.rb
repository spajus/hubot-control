class Script

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
    File.exist?(@file) ? File.read(@file) : ''
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
