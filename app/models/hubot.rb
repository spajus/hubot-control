require 'socket'
class Hubot < ActiveRecord::Base

  $shells ||= {}

  validates :name, uniqueness: true, presence: true
  validates :port, uniqueness: true, presence: true, numericality: true
  validates :test_port, uniqueness: true, presence: true, numericality: true

  before_create :install
  before_destroy :uninstall

  def self.base_dir
    @@base_dir ||= Rails.root.join('hubots')
  end

  def config
    @config ||= HubotConfig.new(self)
  end

  def output
    @output || ''
  end

  def log(val)
    @output = "#{output}#{val}"
  end

  def status
    pid.nil? ? 'Not running' : "Running (pid: #{pid})"
  end

  def to_s
    name
  end

  def shell
    $shells[id]
  end

  def self.shell(id)
    Rails.logger.debug("Getting shell: #{id} from #{$shells}")
    $shells[id.to_i]
  end

  def start_shell(adapter='shell')
    $shells[id] ||= Shell.new(start_cmd(adapter), env(adapter), cwd)
  end

  def stop_shell
    shell = $shells.delete(id)
    shell.close
  end

  def url(path='/')
    "http://#{Socket.gethostname}:#{port}#{path}"
  end

  def test_url(path='/')
    "http://#{Socket.gethostname}:#{test_port}#{path}"
  end

  private

    def start_cmd(adapter = 'shell')
      "bin/hubot -n '#{name}' -a #{adapter}"
    end

    def env(adapter='shell')
      {
        PORT: adapter == 'shell' ? self.test_port : self.port
      }
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
