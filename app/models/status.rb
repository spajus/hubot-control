class Status

  class << self

    def node
      @@node ||= `node -v`
    end

    def npm
      @@npm ||= `npm -v`
    end

    def coffee
      @@coffee ||= `coffee -v`
    end

    def hubot
      @@hubot ||= `hubot -v`
    end

    def hubot_dir_writable?
      @@hubot_dir_writable ||= File.writable? Hubot.base_dir
    end

    def sys_user
      @@sys_user ||= `whoami`
    end

    def can_run?
      self.node && self.npm && self.coffee && self.hubot_dir_writable?
    end

  end

end
