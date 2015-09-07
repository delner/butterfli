require 'spec_helper'

describe Butterfli::Configuration::SyndicateWriter do
  context "when configured within a processor in Butterfli" do
    before do
      Butterfli.processor = nil
      Butterfli.configure do |config|
        config.processor :monolith do |processor|
          processor.writer :syndicate
        end
      end
    end
    after { Butterfli.processor = nil }
    subject { Butterfli.processor.writers.first }
    it do
      expect(subject).to be_a_kind_of(Butterfli::SyndicateWriter)
    end
  end
end