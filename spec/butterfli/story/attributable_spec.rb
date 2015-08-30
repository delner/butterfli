require 'spec_helper'

shared_examples "attributable" do
  describe "#references" do
    it_behaves_like "it has a field", "references"

    context do
      subject { super().references }
      it_behaves_like "it has a field", "source_uri"
      it_behaves_like "it has a field", "source_id"
      it_behaves_like "it has a field", "source_type"
    end
  end
end