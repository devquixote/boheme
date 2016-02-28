require "boheme/version"
require "boheme/containers"
require "boheme/dsl"
require "boheme/instance"

module Boheme
  def self.parse(&source)
    instance = Instance.new(&source)
    instance.interpret!
    instance.launch!
    instance
  end
end

