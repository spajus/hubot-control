require 'io/console'
require 'pty'
require 'sys/proctable'

class Shell

  # Matches all ANSI color and control codes
  ANSI_PATTERN = /(\e\[(([\d;]+)m|\d{1,2}([A-Z])))/

  def initialize(command, env=nil, cwd=nil)
    STDOUT.sync
    @master_pty, slave_pty = PTY.open
    slave_pty.raw! # disable newline conversion.
    read_pipe, @write_pipe = IO.pipe
    command = "#{env.collect { |k,v| "#{k}=#{v}" }.join(' ')} #{command}" if env
    command = "cd #{cwd} && #{command}" if cwd
    command =
    @pid = spawn(command, in: read_pipe, err: :out, out: slave_pty)
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
    child_pids = Sys::ProcTable.ps.select { |pe| pe.ppid == @pid }.map(&:pid)
    child_pids.each { |p| Process.kill("HUP", p) }
    Process.kill("HUP", @pid)
    Process.waitpid(@pid)
  rescue => e
    Rails.logger.error("Could not close hubot shell: #{e}")
    Rails.logger.error(e)
  end

end
