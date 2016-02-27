require 'boheme/containers/base_container'
require 'boheme/containers/emulated_container'

module Boheme::Containers
  @service_factory = nil
  @task_factory = nil

  class << self
    def service_factory(&factory)
       @service_factory = lambda &factory
    end

    def task_factory(&factory)
      @task_factory = lambda &factory
    end

    def build_service
      @service_factory.call
    end

    def build_task
      @task_factory.call
    end
  end
end
