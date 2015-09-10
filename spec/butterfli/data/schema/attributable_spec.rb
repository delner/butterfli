require 'spec_helper'

shared_examples "attributable" do
  describe "#references" do
    it_behaves_like "it has a field", "references"

    context do
      subject { super().references }
      it_behaves_like "it has a field", "source_uri"
    end
  end
end