require 'spec_helper'
require 'find'

module Boheme
  describe Runner do
    let(:examples_dir) do
      File.expand_path(File.join(File.dirname(__FILE__), "../../examples"))
    end
    let(:example_files) do
      Find.find(examples_dir).map do |path|
        if path =~ /\.boheme$/
          path
        else
          nil
        end
      end.compact
    end
    let(:config) do
      OpenStruct.new
    end

    let(:runner) do 
      Runner.new(examples_dir, config)
    end


    around(:each) do |example|
      Runner.send :public, :collect_dsl_files
      example.run
      Runner.send :private, :collect_dsl_files
    end

    describe "#collect_dsl_files" do
      it "should return the .boheme files found in the target path" do
        expect(runner.collect_dsl_files.sort).to eql(example_files.sort)
      end
    end
  end
end
