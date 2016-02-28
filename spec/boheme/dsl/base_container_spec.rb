require 'spec_helper'
require_relative 'shared_base_container_spec'

module Boheme::DSL
  describe BaseContext do
    let(:boheme) { Boheme::Instance.new {} }
    let(:context) { BaseContext.new(boheme) }
    it_should_behave_like "base container"
  end
end
