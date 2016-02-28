require 'spec_helper'
require_relative 'shared_base_container_spec'

module Boheme::DSL
  describe RootContext do
    let(:boheme) { Boheme::Instance.new {} }
    let!(:context) do
      RootContext.new(boheme).tap do |root|
        root.name "project"
        root.image "java8"
      end
    end
    let!(:service) do
      context.service :service do
        image "redis"
      end
    end
    let!(:task) do
      context.task :task do
        image "build"
      end
    end

    it_should_behave_like "base container"

    describe "#driver" do
      it "should set the @driver if an arg is passed" do
        context.driver(:docker_cli)
        expect(context.driver).to eql(:docker_cli)
      end

      it "should raise error if illegal argument passed" do
        expect{context.driver(:foo)}.to raise_error(ArgumentError)
      end
    end

    describe "#service" do
      it "should return a named service" do
        expect(service.name).to eql(:service)
      end

      it "should set the services parent to the root context" do
        expect(service.parent).to eql(context)
      end

      it "should register the service as a container_context" do
        expect(context.container_contexts).to include(service)
      end
    end

    describe "#task" do
      it "should return a named task" do
        expect(task.name).to eql(:task)
      end

      it "should set the tasks parent to the root context" do
        expect(task.parent).to eql(context)
      end

      it "should register the task as a container_context" do
        expect(context.container_contexts).to include(task)
      end
    end

    describe "#build_all!" do
      let(:container) { double(Boheme::Containers::EmulatedContainer) }
      before do
        allow(service).to receive(:build!).and_return(container)
        allow(task).to receive(:build!).and_return(container)
      end

      it "should call for each container_context to be built" do
        expect(context.build_all!).to eql([container, container])
      end
    end
  end
end
