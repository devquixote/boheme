RSpec.shared_examples "container builder" do
    before do
      Boheme::Containers.service_factory do
        Boheme::Containers::EmulatedContainer.new_service
      end

      Boheme::Containers.task_factory do
        Boheme::Containers::EmulatedContainer.new_task
      end
    end

    let(:container) { context.build! }
    describe "#build!" do
      it "should return container w/context name" do
        expect(container.name).to eql("#{root.name}:#{context.name}")
      end

      it "should return container w/context image" do
        expect(container.image).to eql(context.image)
      end

      it "should return container w/context command" do
        expect(container.command).to eql(context.command)
      end

      it "should return container w/context mounts" do
        context.mounts "a" => "b"
        expect(container.mounts).to eql(context.mounts)
      end

      it "should return container w/dependencies" do
        expect(container.dependencies).to eql(["project:mysql"])
      end
    end
end
