module Boheme
  class Instance
    attr_reader :source, :root
    def initialize(&source)
      raise ArgumentError, "No source block given" unless source
      @source = lambda &source
      @containers = []
    end

    # TODO test me
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

    def containers
      @containers.dup
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
  end
end
