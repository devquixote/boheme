module Boheme::DSL
  module ChildContext
    attr_accessor :parent

    def initialize(boheme)
      super(boheme)
    end

    def full_name
      "#{parent.name}:#{name}"
    end

    def image(image=nil)
      return value_from_self_or_parent(:@image) if image.nil?
      @image = image
    end

    def command(command=nil)
      return value_from_self_or_parent(:@command) if command.nil?
      @command = command
    end

    def mounts(mounts=nil)
      if (mounts == nil)
        return @mounts.dup.merge(parent.mounts)
      end
      @mounts.merge! mounts
    end

    def value_from_self_or_parent(name)
      result = self.instance_variable_get(name)
      if result.nil? && parent
        result = parent.instance_variable_get(name)
      end
      result
    end
  end
end
