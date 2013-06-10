require 'io/console'
require 'pty'

class Shell

  # Matches all ANSI color and control codes
  ANSI_PATTERN = /(\e\[(([\d;]+)m|\d{1,2}([A-Z])))/

  def self.child_pids(pid)
    Process.getpgid(pid)
    pipe = IO.popen("ps -ef | grep #{pid}")
    pipe.readlines.map do |line|
      parts = line.split(/\s+/)
      parts[2].to_i if parts[3] == pid.to_s and parts[2] != pipe.pid.to_s
    end.compact
  rescue => e
    Rails.logger.error(e)
    []
  end

  def self.kill_tree(pid)
    self.child_pids(pid).each { |p| Process.kill("TERM", p) }
    Process.kill("TERM", pid)
    Process.waitpid(pid)
  rescue Errno::ESRCH
    Rails.logger.error("Couldn't find process with pid: #{pid}")
  end

  def self.prepare(command, env=nil, cwd=nil)
    command = "#{env.collect { |k,v| "#{k}=#{v}" }.join(' ')} #{command}" if env
    command = "cd #{cwd} && #{command}" if cwd
    command
  end

  def initialize(command, env=nil, cwd=nil)
    STDOUT.sync
    @master_pty, slave_pty = PTY.open
    slave_pty.raw! # disable newline conversion.
    read_pipe, @write_pipe = IO.pipe
    cmd = Shell.prepare(command, env, cwd)
    @pid = spawn(cmd, in: read_pipe, err: :out, out: slave_pty)
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
