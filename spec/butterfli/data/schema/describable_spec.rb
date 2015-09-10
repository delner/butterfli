require 'spec_helper'

shared_examples "describable" do
  describe "#text" do
    it_behaves_like "it has a field", "text"
  end

  context do
    subject { super().text }
    it_behaves_like "it has a field", "title"
    it_behaves_like "it has a field", "body"
  end
end