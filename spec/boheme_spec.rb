require 'spec_helper'

describe Boheme do
  it 'has a version number' do
    expect(Boheme::VERSION).not_to be nil
  end

  describe "#parse" do
    it "should register the instance" do
      Boheme.instance_variable_set(:@instances, Set.new)
      expect(Boheme.instances).to be_empty
      Boheme.parse {}
      expect(Boheme.instances).to_not be_empty
    end
  end

  describe "evaluated integration" do
    it "should register the instance with Boheme" do
      Boheme.instance_variable_set(:@instances, Set.new)
      expect(Boheme.instances).to be_empty
      src = <<-SRC
        Boheme.parse do |boheme|
          boheme.name "test"
          boheme.image "blah"
        end
      SRC
      eval(src)
      expect(Boheme.instances).to_not be_empty
    end
  end
end
