require 'spec_helper'

shared_examples "shareable" do
  describe "#shares" do
    it_behaves_like "it has a field", "shares"
  end

  # TODO: Add coverage for Share
end