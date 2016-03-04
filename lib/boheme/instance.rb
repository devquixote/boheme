module Boheme
  class Instance
    attr_reader :source, :root
    def initialize(&source)
      raise ArgumentError, "No source block given" unless source
      @source = lambda &source
      @containers = []
    end

    def interpret!
      @root = DSL::RootContext.new(self)
      root.mounts Dir.pwd => "/usr/local/src/project"
      source.call(root)
      true
    end

    def launch!
      root.build_all!
      containers.each(&:launch!)
      containers
    end

    def update_status
      containers.each(&:update_status)
    end

    def containers
      @containers
    end

    def container(name)
      @containers.detect{|c| c.name == name}
    end

    def set_dependency(dependency_name, dependent_container)
      dependency_container = container(full_name(dependency_name))
      raise ArgumentError, "No container named #{dependency_name}" unless dependency_container
      dependent_container.dependencies << dependency_container
      dependency_container.dependents << dependent_container
      true
    end

    def services
      containers.select(&:service?)
    end

    def tasks
      containers.select(&:task?)
    end

    def finished_containers
      containers.select(&:finished?)
    end

    def failed_containers
      containers.select(&:failed?)
    end

    def successful_containers
      containers.select(&:successful?)
    end

    def fully_running?
      # services should run forever until we terminate the instance
      return false if has_services_that_have_finished?

      # should be ready to shut down when all tasks without dependents
      # are finished
      return false if all_leaf_tasks_finished?
      true
    end

    def successful?
      return nil if failed?.nil?
      !failed?
    end

    def failed?
      return nil if fully_running?
      !finished_containers.select(&:failed?).empty?
    end

    def build_service
      Containers.build_service.tap do |service|
        @containers << service
      end
    end

    def build_task
      Containers.build_task.tap do |task|
        @containers << task
      end
    end

    private

    def failed_tasks?
      !containers.select(&:task?).detect(&:failed?).nil?
    end

    def has_services_that_have_finished?
      !services.detect(&:finished?).nil?
    end

    def all_leaf_tasks_finished?
      leafs = tasks.select(&:leaf?)
      finished_leafs = leafs.select(&:finished?)
      leafs.size == finished_leafs.size
    end

    def full_name(name)
      if name =~ /:/
        name
      else
        "#{root.name}:#{name}"
      end
    end
  end
end
