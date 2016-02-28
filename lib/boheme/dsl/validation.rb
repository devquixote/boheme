module Boheme::DSL
  module Validation
    def validate!
      raise "No name for boheme root context" unless parent.name
      raise "No name for #{self.class}" unless name
      raise "No image for #{self.class}" unless image
    end
  end
end
