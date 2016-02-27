require 'spec_helper'

module Boheme
  describe Containers do
    before do
      Containers.service_factory do
        Containers::EmulatedContainer.new_service
      end

      Containers.task_factory do
        Containers::EmulatedContainer.new_task
      end
    end

    describe "#build_service" do
      it "should build using the specified service factory" do
        expect(Containers.build_service.type).to eql(:SERVICE)
      end
    end

    describe "#build_task" do
      it "should build using the specified task factory" do
        expect(Containers.build_task.type).to eql(:TASK)
      end
    end
  end
end
