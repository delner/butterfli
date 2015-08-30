require 'spec_helper'

describe Butterfli::Story do
  let(:base_class) { Butterfli::Story }
  it_behaves_like "schemable"

  context "instance" do
    subject { base_class.new }
    it_behaves_like "authorable"
    it_behaves_like "attributable"
    it_behaves_like "commentable"
    it_behaves_like "describable"
    it_behaves_like "identifiable"
    it_behaves_like "imageable"
    it_behaves_like "likeable"
    it_behaves_like "mappable"
    it_behaves_like "shareable"
    it_behaves_like "taggable"

    it_behaves_like "it has a field", "type"
    it_behaves_like "it has a field", "created_date"
  end
end