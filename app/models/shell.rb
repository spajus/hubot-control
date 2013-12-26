require 'io/console'
require 'pty'

class Shell

  # Matches all ANSI color and control codes
  ANSI_PATTERN = /(\e\[(([\d;]+)m|\d{1,2}([A-Z])))/

  def self.child_pids(pid)
    pipe = IO.popen("ps -ef | grep #{pid}")
    pipe.readlines.map { |line| child_pid(line, pid, pipe.pid) }.compact
  rescue => e
    Rails.logger.error(e)
    []
  ensure
    pipe.close
  end

  def self.child_pid(line, parent_pid, own_pid)
    parts = line.strip.split(/\s+/)
    parts[1].to_i if parts[2] == parent_pid.to_s and parts[1] != own_pid.to_s
  end

  def self.kill_tree(pid)
    self.child_pids(pid).each do |p|
      self.child_pids(p).each { |pp| self.kill_tree(pp) }
      Process.kill("TERM", p)
    end
    Process.kill("TERM", pid)
  rescue Errno::ESRCH, Errno::ECHILD
    Rails.logger.error("Couldn't find process with pid: #{pid}")
  end

  def self.prepare(command, env=nil, cwd=nil)
    command = "#{env.collect { |k,v| "#{k}=#{Shellwords.escape(v)}" }.join(' ')} #{command}" if env
    command = "cd #{cwd} && #{command}" if cwd
    command
  end

  def self.run(command)
    `#{command}` unless Rails.env.test?
  end

  def self.system(command)
    Kernel.system(command) unless Rails.env.test?
  end

  def self.spawn(cmd, options)
    Kernel.spawn(cmd, options) unless Rails.env.test?
  end

  def initialize(command, env=nil, cwd=nil)
    STDOUT.sync
    @master_pty, slave_pty = PTY.open
    slave_pty.raw! # disable newline conversion.
    read_pipe, @write_pipe = IO.pipe
    cmd = Shell.prepare(command, env, cwd)
    @pid = Shell.spawn(cmd, in: read_pipe, err: :out, out: slave_pty)
    read_pipe.close
    slave_pty.close
  end

  def read # and don't freeze when output is unflushed
    timeout(0.5) do
      line = @master_pty.gets
      line.gsub(ANSI_PATTERN, '') if line
    end
  rescue Timeout::Error
    nil
  end

  def readlines
    lines = []
    line = self.read
    while not line.nil?
      lines << line.strip
      line = self.read
    end
    lines.delete('')
    lines.join("\n")
  end

  def write(text)
    @write_pipe.puts text
  end

  def close
    @write_pipe.close
    @master_pty.close
    Shell.kill_tree(@pid)
  rescue => e
    Rails.logger.error("Could not close hubot shell: #{e}")
    Rails.logger.error(e)
  end

end
