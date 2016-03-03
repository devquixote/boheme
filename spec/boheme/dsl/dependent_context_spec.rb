require 'spec_helper'
require_relative 'shared_dependent_context_spec'

module Boheme::DSL
  describe DependentContext do
    class Foo < BaseContext
      include DependentContext

      def initialize(boheme)
        super(boheme)
      end
    end
    let!(:boheme) { Boheme::Instance.new {} }
    let!(:context) { Foo.new(boheme) }

    it_should_behave_like "dependent container"
  end
end
