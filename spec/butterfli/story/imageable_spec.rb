require 'spec_helper'

shared_examples "imageable" do
  describe "#images" do
    it_behaves_like "it has a field", "images"
  end

  context do
    subject { super().images }
    it_behaves_like "it has a field", "thumbnails"
  end

  # TODO: Add coverage for Image
end