require 'spec_helper'
require 'shared/test_container_factories'

module Boheme
  describe Containers do
    include_context "test container factories"

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
