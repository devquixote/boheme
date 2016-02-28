module Boheme::DSL
  class RootContext < BaseContext
    DRIVERS = [:docker_cli]

    def initialize(boheme)
      super(boheme)
      @container_contexts = []
    end

    def driver(driver=nil)
      return @driver if driver.nil?
      unless RootContext::DRIVERS.include? driver
        raise ArgumentError, "#{driver} not supported driver"
      end
      @driver = driver
    end

    def service(name, &block)
      service_context = ServiceContext.new(boheme, name)
      service_context.parent = self
      service_context.instance_exec(&block)
      @container_contexts << service_context
      service_context
    end

    def task(name, &block)
      task_context = TaskContext.new(boheme, name)
      task_context.parent = self
      task_context.instance_exec(&block)
      @container_contexts << task_context
      task_context
    end

    alias_method :infrastructure, :service
    alias_method :app, :service
    alias_method :tests, :task

    def build_all!
      container_contexts.map(&:build!)
    end

    def container_contexts
      @container_contexts.dup
    end
  end
end
