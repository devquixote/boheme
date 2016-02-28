require 'spec_helper'
require_relative 'shared_base_container_spec'
require_relative 'shared_dependent_context_spec'
require_relative 'shared_child_context_spec'
require_relative 'shared_build_context_spec'
require_relative 'shared_validation_spec.rb'

module Boheme::DSL
  describe ServiceContext do
    let(:boheme) { Boheme::Instance.new {} }
    let(:root) do
      Boheme::DSL::RootContext.new(boheme).tap do |root|
        root.name "project"
      end
    end
    let(:context) do
      ServiceContext.new(boheme, "service").tap do |service_ctx|
        service_ctx.parent = root
        service_ctx.image "java"
        service_ctx.command "echo test"
        service_ctx.dependent_on "mysql"
      end
    end
    it_should_behave_like "base container"
    it_should_behave_like "dependent container"
    it_should_behave_like "child context"
    it_should_behave_like "container builder"
    it_should_behave_like "a self validator"
  end
end
