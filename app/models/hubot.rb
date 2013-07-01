require 'socket'
class Hubot < ActiveRecord::Base

  serialize :variables, Hash

  $shells ||= {}

  validates :title, uniqueness: true, presence: true
  validates :name, presence: true
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

  def running?
    pid.present? && Shell.child_pids(pid).any?
  end

  def status
    running? ? "Running (pid: #{Shell.child_pids(pid).join(', ')})" : 'Not running'
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

  def install_packages
    output = system("cd #{cwd} && npm install")
    raise "Failed installing dependencies with 'npm install': #{$?}" unless output
  end

  def start
    cmd = Shell.prepare(start_cmd(adapter, true), env(adapter), cwd)
    cmd = "bin/daemonize '#{cmd}' '#{self.pid_path}'"
    if config.before_start_exists?
      output = `#{File.expand_path(File.join(location, 'before_start.sh'))} 2>&1`
      File.open(log_path, 'a+') { |f| f.write(output) } if output
      return :error, "Failed running before_start.sh: #{output}" unless $?.success?
    end
    if system cmd
      self.pid = File.read(self.pid_path)
      Rails.logger.debug("PID: #{self.pid}")
      self.save
      return :notice, "Hubot started" if Shell.child_pids(self.pid).any?
    end
    return :error, "Hubot did not start, check log output"
  end

  def stop
    Shell.kill_tree(self.pid)
    self.pid = nil
    self.save
  end

  def log_tail(n=10)
    `tail -n #{n} #{log_path}`.strip
  end

  def start_shell
    $shells[id] ||= Shell.new(start_cmd('shell'), env('shell'), cwd)
  end

  def stop_shell
    shell = $shells.delete(id)
    shell.close
  end

  def url(path='/', hostname = nil)
    hostname ||= Socket.gethostname
    "http://#{hostname}:#{port}#{path}"
  end

  def test_url(path='/')
    "http://#{Socket.gethostname}:#{test_port}#{path}"
  end

  def log_path
    File.join(self.location, 'hubot.log')
  end

  def pid_path
    File.join(self.location, 'hubot.pid')
  end

  def self.find_free_ports
    ports = Hubot.select("max(port) as port, max(test_port) as test_port").take!
    return ports.port || 8000, ports.test_port || 9000
  end

  private

    def start_cmd(adapter = 'shell', log = false)
      cmd = "bin/hubot -n '#{name}' -a #{adapter}"
      cmd = "#{cmd} 2>&1 >> #{log_path}" if log
      cmd
    end

    def env(adapter='shell')
      (variables || {}).merge({ PORT: adapter == 'shell' ? self.test_port : self.port })
    end

    def cwd
      self.location
    end

    def install
      self.location = File.join(Hubot.base_dir, title.parameterize)
      log `hubot --create #{self.location}`
      log `cd #{self.location} && bin/hubot -v`
    end

    def uninstall
      log `rm -rf #{self.location}`
    end
end
