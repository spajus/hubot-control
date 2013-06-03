class OS

  class << self

    KINDS = {
      macosx: {
        name: 'Mac OS',
        supported: true,
      },
      linux: {
        name: 'Linux',
        supported: true,
      },
      unix: {
        name: 'UNIX',
        supported: true,
      },
      windows: {
        name: 'Windows',
        supported: false,
      },
      unknown: {
        name: 'Unknown',
        supported: false,
      },
    }

    def kind
      @@os ||= (
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          :unknown
        end
      )
    end

    def current
      KINDS[self.kind]
    end

    def name
      current[:name]
    end

    def supported?
      current[:supported]
    end

  end

end
