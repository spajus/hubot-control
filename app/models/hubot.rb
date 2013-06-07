class Hubot < ActiveRecord::Base

  @@shells ||= {}

  validates :name, uniqueness: true, presence: true
  validates :port, uniqueness: true, presence: true, numericality: true

  before_create :install
  before_destroy :uninstall

  def self.base_dir
    @@base_dir ||= Rails.root.join('hubots')
  end

  def output
    @output || ''
  end

  def log(val)
    @output = "#{output}#{val}"
  end


  def to_s
    name
  end

  def shell
    @@shells[id]
  end

  def start_shell(adapter='shell')
    @@shells[id] ||= Shell.new(start_cmd(adapter), env, cwd)
  end

  def stop_shell
    shell = @@shells.delete(id)
    shell.close
  end

  private

    def start_cmd(adapter = 'shell')
      "bin/hubot -a #{adapter}"
    end

    def env
      { PORT: self.port }
    end

    def cwd
      self.location
    end

    def install
      self.location = File.join(Hubot.base_dir, name.parameterize)
      log `hubot --create #{self.location}`
      log `cd #{self.location} && bin/hubot -v`
    end

    def uninstall
      log `rm -rf #{self.location}`
    end
end
