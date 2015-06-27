require 'spec_helper'

shared_examples "taggable" do
  describe "#tags" do
    it_behaves_like "it has a field", "tags"
  end
end