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

  def exists?
    File.exist? self.location
  end

  def running?
    pid.present? && Shell.child_pids(pid).any?
  end

  def status
    return "Missing in file system!" unless exists?
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
    output = Shell.system("cd #{cwd} && npm install")
    raise "Failed installing dependencies with 'npm install': #{$?}" unless output
  end

  def start
    error = execute_before_start
    return :error, error if error
    success = execute_start_cmd
    return :notice, success if success
    return :error, "Hubot did not start, check log output"
  rescue => e
    return :error, "Hubot did not start: #{e}"
  end

  def stop
    Shell.kill_tree(self.pid)
    self.pid = nil
    self.save
  end

  def log_tail(n = 10)
    Shell.run("tail -n #{n} #{log_path}").try(:strip)
  end

  def start_shell
    $shells[id] ||= Shell.new(start_cmd('shell'), env('shell'), cwd)
  end

  def stop_shell
    shell = $shells.delete(id)
    shell.close
  end

  def url(path = '/', hostname = nil)
    hostname ||= Socket.gethostname
    "http://#{hostname}:#{port}#{path}"
  end

  def test_url(path = '/')
    "http://#{Socket.gethostname}:#{test_port}#{path}"
  end

  def log_path
    File.join(self.location, 'hubot.log')
  end

  def pid_path
    File.join(self.location, 'hubot.pid')
  end

  def self.find_free_ports
    ports = Hubot.select("max(port) as port, max(test_port) as test_port").take
    if ports && ports.port && ports.test_port
      return ports.port + 1, ports.test_port + 1
    else
      return 8000, 9000
    end
  end

  private

    def execute_before_start
      return unless config.before_start_exists?
      output = Shell.run("#{File.expand_path(File.join(location, 'before_start.sh'))} 2>&1")
      File.open(log_path, 'a+') { |f| f.write(output) } if output
      return "Failed running before_start.sh: #{output}" unless $?.success?
    end

    def execute_start_cmd
      cmd = Shell.prepare(start_cmd(adapter, true), env(adapter), cwd)
      cmd = "bin/daemonize '#{cmd}' '#{self.pid_path}'"
      return unless Shell.system(cmd)
      read_pid
      Rails.logger.debug("PID: #{self.pid}")
      self.save
      return "Hubot started" if Shell.child_pids(self.pid).any?
    end

    def read_pid
      self.pid = File.read(self.pid_path)
    rescue
      sleep 3
      self.pid = File.read(self.pid_path)
    end

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
      log Shell.run("cd #{self.location} && yo hubot --name='#{name}' --adapter=#{adapter} --defaults")
      log Shell.run("cd #{self.location} && bin/hubot -v")
    end

    def uninstall
      log Shell.run("rm -rf #{self.location}")
    end
end
