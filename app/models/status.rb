class Status

  class << self

    def node
      @@node ||= `node -v`.try(:strip)
    end

    def npm
      @@npm ||= `npm -v`.try(:strip)
    end

    def coffee
      @@coffee ||= `coffee -v`.try(:strip)
    end

    def hubot
      @@hubot ||= `hubot -v`.try(:strip)
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
        FileUtils.mkdir_p(Hubot.scripts_dir)
      rescue
        Rails.logger.error("Failed creating #{Hubot.scripts_dir}: #{e}")
      end
      @@scripts_dir_writable ||= File.writable? Hubot.scripts_dir
    end

    def sys_user
      @@sys_user ||= `whoami`.try(:strip)
    end

    def not_root?
      self.sys_user != 'root'
    end

    def can_run?
      self.node && self.npm && self.coffee && self.hubot_dir_writable? && self.not_root?
    end

  end

end
