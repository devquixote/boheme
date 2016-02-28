RSpec.shared_examples "base container" do
  describe "#name" do
    it "should access the @name" do
      context.name "fubar"
      expect(context.name).to eql("fubar")
    end
  end

  describe "#image" do
    it "should access the @image" do
      context.image "blah"
      expect(context.image).to eql("blah")
    end
  end

  describe "#command" do
    it "should access the @command" do
      context.command "blah"
      expect(context.command).to eql("blah")
    end
  end

  describe "#mounts" do
    it "should collect host/container mounts" do
      context.mounts a: :b
      context.mounts c: :d
      expect(context.mounts).to eql({a: :b, c: :d})
    end
  end
end
