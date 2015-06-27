require 'spec_helper'

shared_examples "mappable" do
  describe "#location" do
    it_behaves_like "it has a field", "location"
  end

  context do
    subject { super().location }
    it_behaves_like "it has a field", "lat"
    it_behaves_like "it has a field", "lng"
  end
end