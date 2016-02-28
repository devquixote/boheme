RSpec.shared_examples "dependent container" do
  it "should allow dependencies to be declared and fetched" do
    context.dependent_on :foo
    expect(context.dependencies).to include(:foo)
  end
end
