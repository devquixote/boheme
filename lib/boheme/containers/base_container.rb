module Boheme::Containers
  class BaseContainer
    attr_reader :status, :id, :type
    attr_accessor :name, :command, :image
    STATUSES = [:NEW, :LAUNCHED, :READY, :EXECUTING, :FINISHING, :SUCCESSFUL, :FAILED]
    TYPES = [:TASK, :SERVICE]

    def self.new_service
      raise NotImplementedError
    end

    def self.new_task
      raise NotImplementedError
    end

    def initialize(type)
      @status = :NEW
      @dependencies = []
      @mounts = {}
      @type = type
    end

    STATUSES.each do |status|
      method_name = "#{status.downcase}?"
      define_method(method_name) {@status == status}
    end

    def finished?
      status == :SUCCESSFUL || status == :FAILED
    end

    TYPES.each do |type|
      method_name = "#{type.downcase}?"
      define_method(method_name) {@type == type}
    end

    def launch!
      raise NotImplementedError
    end

    def tear_down!
      raise NotImplementedError
    end

    def get_logs
      raise NotImplementedError
    end

    def depends_on(other_container)
      @dependencies << other_container
      true
    end

    def dependencies_ready?
      (@dependencies.map(&:ready?).uniq == [true])
    end

    def dependencies
      @dependencies.dup
    end

    def mounts(map=nil)
      if (map)
        @mounts.merge! map
      else
        @mounts
      end
    end
  end
end
