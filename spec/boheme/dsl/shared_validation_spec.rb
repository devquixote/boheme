RSpec.shared_examples "a self validator" do
  it "should not raise exception if necessary data is present" do
    expect{context.validate!}.to_not raise_error
  end

  it "should raise exception if parent name is null" do
    root.instance_variable_set(:@name, nil)
    expect{context.validate!}.to raise_error(/No name/)
  end

  it "should raise exception if name is null" do
    context.instance_variable_set(:@name, nil)
    expect{context.validate!}.to raise_error(/No name/)
  end

  it "should raise exception if image is null" do
    root.instance_variable_set(:@image, nil)
    context.instance_variable_set(:@image, nil)
    expect{context.validate!}.to raise_error(/No image/)
  end
end
