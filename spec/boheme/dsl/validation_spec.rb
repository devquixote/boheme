require 'spec_helper'
require_relative 'shared_validation_spec.rb'

module Boheme::DSL
  describe Validation do
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

    it_should_behave_like "a self validator"
  end
end
