require 'spec_helper'

module Boheme::Containers
  describe BaseContainer do
    let(:root) do
      double(Boheme::DSL::RootContext).tap do |root|
        allow(root).to receive(:name).and_return("root")
      end
    end
    let(:boheme) do
      double(Boheme::Instance).tap do |boheme|
        allow(boheme).to receive(:container)
        allow(boheme).to receive(:root).and_return(root)
      end
    end
    let(:container) do
      BaseContainer.new(boheme, :SERVICE).tap do |container|
        container.name = "container"
        #container.parent_name "project"
        #container.container_name "mysql"
      end
    end

    describe "class methods" do
      describe "#new_service" do
        it "should raise NotImplementedError" do
          expect{BaseContainer.new_service}.to raise_error(NotImplementedError)
        end
      end

      describe "#new_task" do
        it "should raise NotImplementedError" do
          expect{BaseContainer.new_task}.to raise_error(NotImplementedError)
        end
      end
    end

    describe "#inxitialize" do
      it "should construct the new container in a NEW status" do
        expect(container.status).to eql(:NEW)
      end
    end

    BaseContainer::STATUSES.each do |status|
      method_name = "#{status.downcase}?"
      describe "##{method_name}?" do
        it "should return true if the container is in the #{status} status" do
          container.instance_variable_set(:@status, status)
          result = container.send(method_name)
          expect(result).to eql(true)
        end

        it "should return false if the container is not in the #{status} status" do
          container.instance_variable_set(:@status, nil)
          result = container.send(method_name)
          expect(result).to eql(false)
        end
      end
    end

    describe "#finished" do
      it "should return true if status is SUCCESSFUL" do
          container.instance_variable_set(:@status, :SUCCESSFUL)
          expect(container.finished?).to eql(true)
      end

      it "should return true if status is FAILED" do
          container.instance_variable_set(:@status, :FAILED)
          expect(container.finished?).to eql(true)
      end

      non_terminal_statuses = BaseContainer::STATUSES - [:SUCCESSFUL, :FAILED]
      non_terminal_statuses.each do |status|
        it "should return false if status is #{status}" do
            container.instance_variable_set(:@status, status)
            expect(container.finished?).to eql(false)
        end
      end
    end

    describe "#launch!" do
      it "should raise NotImplementedError" do
        expect{container.launch!}.to raise_error(NotImplementedError)
      end
    end

    describe "#update_status" do
      it "should raise NotImplementedError" do
        expect{container.update_status}.to raise_error(NotImplementedError)
      end
    end

    describe "#dependencies_ready?" do
      let(:dependency) do
        BaseContainer.new(boheme, :SERVICE).tap do |dependency|
          allow(boheme).to receive(:container).and_return(dependency)
          dependency.name = "dependency"
          container.dependencies << dependency
          dependency.dependents << container
        end
      end

      it "should return true if there are no dependencies" do
        container.instance_variable_set(:@dependencies, [])
        expect(container.dependencies_ready?).to eql(true)
      end

      it "should return true if all dependencies are ready" do
        def dependency.ready?
          true
        end
        expect(container.dependencies_ready?).to eql(true)
      end

      it "should return false if any dependencies are not ready" do
        def dependency.ready?
          false
        end
      end
    end

    describe "dependent methods" do
      let(:dependent) { BaseContainer.new(boheme, :SERVICE) }

      before do
      end

      it "should have Boheme::Instance setup the dependency relationship" do
        allow(boheme).to receive(:set_dependency).with("container", dependent)
        dependent.depends_on container.name
        expect(dependent.boheme).to have_received(:set_dependency).with("container", dependent)
      end

      describe "#leaf?" do
        it "should returs false if the container has any dependents" do
          container.instance_variable_set(:@dependents, [dependent])
          expect(container.leaf?).to eql(false)
        end

        it "should return true if the container has no dependents" do
          expect(container.leaf?).to eql(true)
        end
      end
    end

    describe "#tear_down!" do
      it "hsould raise NotImplementedError" do
        expect{container.tear_down!}.to raise_error(NotImplementedError)
      end
    end

    describe "#get_logs" do
      it "should raise NotImplementedError" do
        expect{container.get_logs}.to raise_error(NotImplementedError)
      end
    end

    describe "#mounts" do
      it "should allow mounts to be specified as host/container pairs" do
        container.mounts("/foo" => "/bar")
        expect(container.mounts).to eql({"/foo" => "/bar"})
      end
    end
  end
end
