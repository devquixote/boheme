module Boheme::DSL
  class BaseContext
    attr_reader :boheme

    def initialize(boheme)
      super()
      @boheme = boheme
      @mounts = {}
    end

    def name(name=nil)
      return @name if name.nil?
      @name = name
    end

    def image(image=nil)
      return @image if image.nil?
      @image = image
    end

    def command(command=nil)
      return @command if command.nil?
      @command = command
    end

    def mounts(mounts=nil)
      return @mounts if mounts.nil?
      @mounts.merge! mounts
    end
  end
end
