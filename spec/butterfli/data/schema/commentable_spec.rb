require 'spec_helper'

shared_examples "commentable" do
  describe "#comments" do
    it_behaves_like "it has a field", "comments"
  end

  # TODO: Add coverage for Comment
end