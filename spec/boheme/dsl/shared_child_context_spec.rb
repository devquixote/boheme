RSpec.shared_examples "child context" do
  let(:parent) do
    Boheme::DSL::BaseContext.new(boheme).tap do |ctx|
      ctx.name "parent"
      ctx.image "parent-image"
      ctx.command "parent-command"
      ctx.mounts "parent" => "parent"
    end
  end
  before { context.parent = parent }

  describe "#full_name" do
    it "should be equal to parent name and child name separated by a colon" do
      context.name "child"
      expect(context.full_name).to eql("parent:child")
    end
  end

  describe "#image" do
    it "should use the image of the child if present" do
      context.image "child-image"
      expect(context.image).to eql("child-image")
    end

    it "should use the image of the parent if child image not present" do
      parent.image "parent-image"
      context.instance_variable_set(:@image, nil)
      expect(context.image).to eql("parent-image")
    end

    it "should return nil if the parent and child images are not present" do
      parent.instance_variable_set(:@image, nil)
      context.instance_variable_set(:@image, nil)
      expect(context.image).to be_nil
    end
  end

  describe "#command" do
    it "should use the command of the child if present" do
      context.command "child-command"
      expect(context.command).to eql("child-command")
    end

    it "should use the command of the parent if child command not present" do
      parent.command "parent-command"
      context.instance_variable_set(:@command, nil)
      expect(context.command).to eql("parent-command")
    end

    it "should return nil if the parent and child commands are not present" do
      parent.instance_variable_set(:@command, nil)
      context.instance_variable_set(:@command, nil)
      expect(context.command).to be_nil
    end
  end

  describe "#mounts" do
    it "should contain the merged mounts from the parent and child" do
      parent.mounts "/parent" => "/parent"
      context.mounts "/child" => "/child"
      expect(context.mounts["/parent"]).to eql("/parent")
      expect(context.mounts["/child"]).to eql("/child")
    end
  end
end
