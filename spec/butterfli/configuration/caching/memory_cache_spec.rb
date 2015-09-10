require 'spec_helper'

describe Butterfli::Configuration::Caching::MemoryCache do
  context "when configured within Butterfli" do
    before do
      Butterfli.cache = nil
      Butterfli.configure do |config|
        config.cache :memory
      end
    end
    after { Butterfli.cache = nil; Butterfli.configure { } }
    subject { Butterfli.cache.adapter }
    it do
      expect(subject).to be_a_kind_of(Butterfli::Caching::MemoryCacheAdapter)
    end
  end
end