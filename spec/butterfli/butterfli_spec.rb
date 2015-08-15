require 'spec_helper'

describe Butterfli do
  describe "#configuration" do
    subject { Butterfli.configuration }
    it { expect(subject).to be_a_kind_of(Butterfli::Configuration::Base) }
  end
  describe "#configure" do
    subject do
      Butterfli.configure do
        # Do nothing..
      end
    end
    it { expect(subject).to be_a_kind_of(Butterfli::Configuration::Base) }
  end
end