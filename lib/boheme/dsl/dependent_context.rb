require 'set'

module Boheme::DSL
  module DependentContext
    def initialize(boheme)
      super(boheme)
      @dependencies = Set.new
    end

    def dependent_on(*names)
      @dependencies = @dependencies.union(Set.new(names))
    end

    def dependencies
      @dependencies.dup
    end
  end
end
