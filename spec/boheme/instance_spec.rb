require 'spec_helper'

module Boheme
  describe Instance do
    describe "#initialize" do
      it "should blow up if no block is given" do
        expect{Instance.new}.to raise_error(ArgumentError)
      end
    end
  end
end
