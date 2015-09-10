require 'spec_helper'

shared_examples "authorable" do
  describe "#author" do
    it_behaves_like "it has a field", "author"

    context do
      subject { super().author }
      it_behaves_like "it has a field", "username"
      it_behaves_like "it has a field", "name"
    end
  end
end