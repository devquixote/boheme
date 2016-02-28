module Boheme::DSL
  class ServiceContext < BaseContext
    include DependentContext
    include ChildContext
    include Validation

    def initialize(boheme, name)
      super(boheme)
      name(name)
    end

    def build!
      boheme.build_service.tap do |container|
        container.name = self.full_name
        container.image = self.image
        container.command = self.command
        container.mounts self.mounts
        self.dependencies.each do |dep_name|
          container.depends_on "#{parent.name}:#{dep_name}"
        end
      end
    end
  end
end
