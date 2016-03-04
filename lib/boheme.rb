require "boheme/version"
require "boheme/containers"
require "boheme/dsl"
require "boheme/instance"
require "boheme/runner"

module Boheme
  @instances = []
  class << self
    def register(instance)
      @instances << instance
    end

    def instances
      @instances
    end
  end

  def self.parse(&source)
    instance = Instance.new(&source)
    Boheme.register instance
    instance
  end
end

