require 'boheme/containers/base_container'
require 'boheme/containers/emulated_container'

module Boheme::Containers
  LogEntry = Struct.new(:time, :name, :entry)
end
