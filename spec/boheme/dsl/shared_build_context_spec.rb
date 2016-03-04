require 'shared/test_container_factories'

RSpec.shared_examples "container builder" do
    include_context "test container factories"

    let(:container) { context.build! }
    let!(:dependency) do
      boheme.build_service.tap do |service|
        service.name = "project:mysql"
      end
    end
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
        expect(container.dependencies).to eql([dependency])
      end
    end
end
