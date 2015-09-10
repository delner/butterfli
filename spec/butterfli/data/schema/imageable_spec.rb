require 'spec_helper'

shared_examples "imageable" do
  describe "#images" do
    it_behaves_like "it has a field", "images"
  end

  context do
    subject { super().images }
    it_behaves_like "it has a field", "thumbnail"
    it_behaves_like "it has a field", "small"
    it_behaves_like "it has a field", "full"
  end

  # TODO: Add coverage for Image
end