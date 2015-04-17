class Status

  class << self

    def node
      @@node ||= Shell.run('node -v').try(:strip)
    end

    def npm
      @@npm ||= Shell.run('npm -v').try(:strip)
    end

    def coffee
      @@coffee ||= Shell.run('coffee -v').try(:strip)
    end

    def hubot
      @@hubot ||= Shell.run('hubot -v').try(:strip)
    end

    def yo
      @@yo ||= Shell.run('yo --version').try(:strip)
    end

    def hubot_dir_writable?
      begin
        FileUtils.mkdir_p(Hubot.base_dir)
      rescue => e
        Rails.logger.error("Failed creating #{Hubot.base_dir}: #{e}")
      end
      @@hubot_dir_writable ||= File.writable? Hubot.base_dir
    end

    def scripts_dir_writable?
      begin
        FileUtils.mkdir_p(Script.base_dir)
      rescue
        Rails.logger.error("Failed creating #{Script.base_dir}: #{e}")
      end
      @@scripts_dir_writable ||= File.writable? Script.base_dir
    end

    def sys_user
      @@sys_user ||= Shell.run('whoami').try(:strip)
    end

    def not_root?
      self.sys_user != 'root'
    end

    def can_run?
      self.node \
        && self.npm \
        && self.coffee \
        && self.hubot \
        && self.hubot_dir_writable? \
        && self.not_root?
    end

  end

end
