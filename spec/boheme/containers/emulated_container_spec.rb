require 'spec_helper'

module Boheme::Containers
  describe EmulatedContainer do
    let(:boheme) { Boheme::Instance.new {} }

    describe "class methods" do
      describe "#new_service" do
        it "should return a container of type :SERVICE" do
          expect(EmulatedContainer.new_service(nil).type).to eql(:SERVICE)
        end
      end

      describe "#new_task" do
        it "should return a container of type :TASK" do
          expect(EmulatedContainer.new_task(nil).type).to eql(:TASK)
        end
      end
    end

    context "acting as SERVICE" do
      let(:container) { EmulatedContainer.new(boheme, :SERVICE, 0.2) }

      describe "#launch!" do
        it "should change status to LAUNCHED" do
          container.launch!
          expect(container.launched?).to eql(true)
        end

        it "should change status to READY after LAUNCHED" do
          container.launch!
          sleep(0.4)
          container.update_status
          expect(container.ready?).to eql(true)
        end
      end

      describe "#get_logs" do
        let(:logs) { container.get_logs }
        it "should return all status changes" do
          container.launch!
          sleep(0.3)
          container.update_status
          container.tear_down!
          sleep(0.3)
          container.update_status
          expect(logs[0]).to match(/NEW/)
          expect(logs[1]).to match(/LAUNCHED/)
          expect(logs[2]).to match(/READY/)
          expect(logs[3]).to match(/FINISHING/)
          expect(logs[4]).to match(/SUCCESSFUL/)
        end
      end
    end

    context "acting as TASK" do
      let(:container) { EmulatedContainer.new(boheme, :TASK, 0.2) }

      describe "#launch!" do
        it "should change status to LAUNCHED" do
          container.launch!
          expect(container.launched?).to eql(true)
        end

        it "should change status to EXECUTING after LAUNCHED" do
          container.launch!
          sleep(0.25)
          container.update_status
          expect(container.executing?).to eql(true)
        end

        it "should change status to FINISHING after EXECUTING" do
          container.launch!
          sleep(0.25)
          container.update_status
          sleep(0.25)
          container.update_status
          expect(container.finishing?).to eql(true)
        end

        it "should change status to SUCCESSFUL after FINISHING" do
          container.launch!
          sleep(0.25)
          container.update_status
          sleep(0.25)
          container.update_status
          sleep(0.25)
          container.update_status
          expect(container.successful?).to eql(true)
        end
      end

      describe "#get_logs" do
        let(:logs) { container.get_logs }
        it "should return all status changes" do
          container.launch!
          sleep(0.3)
          container.update_status
          sleep(0.3)
          container.update_status
          sleep(0.3)
          container.update_status
          expect(logs[0]).to match(/NEW/)
          expect(logs[1]).to match(/LAUNCHED/)
          expect(logs[2]).to match(/EXECUTING/)
          expect(logs[3]).to match(/FINISHING/)
          expect(logs[4]).to match(/SUCCESSFUL/)
        end
      end
    end

    describe "#tear_down!" do
      let(:container) do
        EmulatedContainer.new(boheme, :TASK, 0.2).tap do |container|
          container.launch!
        end
      end

      it "should change status to FINISHING" do
        container.tear_down!
        expect(container.status).to eql(:FINISHING)
      end

      it "should change status from FINISHING to FINISHED" do
        container.tear_down!
        sleep(0.3)
        container.update_status
        expect(container.status).to eql(:SUCCESSFUL)
      end
    end

    describe "#fail!" do
      let(:container) do
        EmulatedContainer.new(boheme, :TASK, 0.2).tap do |container|
          container.launch!
        end
      end

      it "should change status to FAILED" do
        sleep(0.1)
        container.fail!
        expect(container.status).to eql(:FAILED)
      end

      it "should append FAILED event to logs" do
        sleep(0.1)
        container.fail!
        expect(container.get_logs.last).to match(/FAILED/)
      end
    end
  end
end
