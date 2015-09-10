require 'spec_helper'

shared_examples "identifiable" do
  describe "#source" do
    it_behaves_like "it has a field", "source"

    context do
      subject { super().source }
      it_behaves_like "it has a field", "name"
      it_behaves_like "it has a field", "id"
      it_behaves_like "it has a field", "type"
    end
  end
end