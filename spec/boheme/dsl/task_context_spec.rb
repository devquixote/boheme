require 'spec_helper'
require_relative 'shared_base_container_spec'
require_relative 'shared_dependent_context_spec'
require_relative 'shared_child_context_spec'
require_relative 'shared_validation_spec.rb'
require_relative 'shared_build_context_spec'

module Boheme::DSL
  describe TaskContext do
    let(:boheme) { Boheme::Instance.new {} }
    let(:root) do
      Boheme::DSL::RootContext.new(boheme).tap do |root|
        root.name "project"
      end
    end
    let(:context) do
      TaskContext.new(boheme, "task").tap do |task_ctx|
        task_ctx.parent = root
        task_ctx.image "java"
        task_ctx.command "echo test"
        task_ctx.dependent_on "mysql"
      end
    end
    it_should_behave_like "base container"
    it_should_behave_like "dependent container"
    it_should_behave_like "child context"
    it_should_behave_like "a self validator"
    it_should_behave_like "container builder"
  end
end
