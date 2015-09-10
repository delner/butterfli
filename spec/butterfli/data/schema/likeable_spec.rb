require 'spec_helper'

shared_examples "likeable" do
  describe "#likes" do
    it_behaves_like "it has a field", "likes"
  end

  # TODO: Add coverage for Like
end