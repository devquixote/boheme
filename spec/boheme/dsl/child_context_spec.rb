require 'spec_helper'
require_relative 'shared_child_context_spec'

module Boheme::DSL
  describe ChildContext do
    class Foo < BaseContext
      include ChildContext

      def initialize(boheme)
        super(boheme)
      end
    end
    let(:boheme) { Boheme::Instance.new{} }
    let(:context) { Foo.new(boheme) }

    it_should_behave_like "child context"
  end
end
