require 'io/console'
require 'pty'
require 'sys/proctable'

class Shell

  def initialize(command, env=nil, cwd=nil)
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
    timeout(0.05) { @master_pty.gets }
  rescue Timeout::Error
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
