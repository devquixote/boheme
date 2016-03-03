require 'spec_helper'
require 'shared/mocked_container_factories'

module Boheme
  describe Instance do
    include_context "mocked container factories"

    let(:instance) do
      Instance.new do |boheme|
        boheme.name :test
        boheme.image "alpine:latest"

        boheme.service :service do
          # no def
        end

        boheme.task :task do
          # no def
        end
      end
    end
    let(:service) do
      instance.containers.detect{|c| c.service?}
    end
    let(:task) do
      instance.containers.detect{|c| c.task?}
    end

    before do
      instance.interpret!
      instance.launch!
      allow(service).to receive(:name).and_return("test:service")
      allow(task).to receive(:name).and_return("test:task")
    end

    describe "#interpret!" do
      it "should build all containers" do
        # interpret called in before block
        expect(instance.containers).to_not be_empty
      end
    end

    describe "#launch!" do
      it "should pass call to all containers" do
        # launch called in before block
        expect(service).to have_received(:launch!)
        expect(task).to have_received(:launch!)
      end
    end

    describe "#update_status" do
      it "should ask each container to update its status" do
        instance.update_status
        expect(service).to have_received(:update_status)
        expect(task).to have_received(:update_status)
      end
    end

    describe "#initialize" do
      it "should blow up if no block is given" do
        expect{Instance.new}.to raise_error(ArgumentError)
      end
    end

    describe "#containers" do
      it "should return all containers within the boheme instance" do
        expect(instance.containers).to include(service)
        expect(instance.containers).to include(task)
      end
    end

    describe "#container" do
      it "should allow a container to be looked up by name" do
        expect(instance.container("test:service")).to eql(service)
        expect(instance.container("test:task")).to eql(task)
      end
    end

    describe "#services" do
      it "should return all services within the boheme instance" do
        expect(instance.services).to eql([service])
      end
    end

    describe "#tasks" do
      it "should return all tasks within the boheme instance" do
        expect(instance.tasks).to eql([task])
      end
    end

    describe "#finished_containers" do
      it "should return all containers that are finished" do
        allow(service).to receive(:finished?).and_return(true)
        expect(instance.finished_containers).to eql([service])
      end
    end

    describe "#failed_containers" do
      it "should return all containers that were failed" do
        allow(service).to receive(:failed?).and_return(true)
        expect(instance.failed_containers).to eql([service])
      end
    end

    describe "#successful_containers" do
      it "should return all containers that were successful" do
        allow(task).to receive(:successful?).and_return(true)
        expect(instance.successful_containers).to eql([task])
      end
    end

    describe "#fully_running?" do
      it "should return false if the instances has no containers" do
        instance.instance_variable_set(:@containers, [])
        expect(instance.fully_running?).to eql(false)
      end

      it "should return false when any services have finished" do
        allow(service).to receive(:finished?).and_return(true)
        expect(instance.fully_running?).to eql(false)
      end

      it "should return false when all tasks have finished" do
        allow(task).to receive(:leaf?).and_return(true)
        allow(task).to receive(:finished?).and_return(true)
        expect(instance.fully_running?).to eql(false)
      end

      it "should return true when no services have finished or any leaf tasks are unfinished" do
        allow(service).to receive(:finished).and_return(false)
        allow(task).to receive(:leaf?).and_return(true)
        allow(task).to receive(:finished?).and_return(false)
        expect(instance.fully_running?).to eql(true)
      end
    end

    describe "#failed?" do
      it "should return nil if the instance is still fully running" do
        allow(service).to receive(:finished?).and_return(false)
        allow(task).to receive(:leaf?).and_return(true)
        allow(task).to receive(:finished?).and_return(false)
        expect(instance.failed?).to eql(nil)
      end

      it "should return true if any containers have failed" do
        allow(service).to receive(:finished?).and_return(true)
        allow(service).to receive(:failed?).and_return(true)
        allow(task).to receive(:failed?).and_return(false)
        expect(instance.failed?).to eql(true)
      end

      it "should return false if no containers have failed" do
        allow(service).to receive(:finished?).and_return(true)
        allow(service).to receive(:failed?).and_return(false)
        allow(task).to receive(:failed?).and_return(false)
        expect(instance.failed?).to eql(false)
      end
    end

    describe "#successful?" do
      it "should return nil if the instance is still fully running" do
        allow(service).to receive(:finished?).and_return(false)
        allow(task).to receive(:leaf?).and_return(true)
        allow(task).to receive(:finished?).and_return(false)
        expect(instance.successful?).to eql(nil)
      end

      it "should return false if any containers have failed" do
        allow(service).to receive(:finished?).and_return(true)
        allow(service).to receive(:failed?).and_return(true)
        allow(task).to receive(:failed?).and_return(false)
        expect(instance.successful?).to eql(false)
      end

      it "should return true if no containers have failed" do
        allow(service).to receive(:finished?).and_return(true)
        allow(service).to receive(:failed?).and_return(false)
        allow(task).to receive(:failed?).and_return(false)
        expect(instance.successful?).to eql(true)
      end
    end
  end
end
