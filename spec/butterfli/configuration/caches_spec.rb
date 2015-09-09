require 'spec_helper'

describe Butterfli::Configuration::Caches do
  subject { Butterfli::Configuration::Caches }

  # Create fake cache to drive tests
  let(:cache_name) { :test_cache }
  let(:cache_config_class) do
    stub_const 'TestCacheConfig', Class.new(Butterfli::Configuration::Cache)
    TestCacheConfig
  end

  describe "#known_caches" do
    subject { super().known_caches }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_cache" do
    subject { super().register_cache(cache_name, cache_config_class) }

    context "when invoked with a cache name and class" do
      it do
        expect(subject).to eq(cache_config_class)
        expect(Butterfli::Configuration::Caches.known_caches).to include(cache_name)
      end
    end
  end

  describe "#instantiate_cache" do
    before { Butterfli::Configuration::Caches.register_cache(cache_name, cache_config_class) }

    subject { super().instantiate_cache(cache_name) }

    context "when invoked with a known cache" do
      context "(as a Symbol)" do
        let(:cache_name) { :test_cache }
        it { expect(subject).to be_a_kind_of(cache_config_class) }
      end
      context "(as a String)" do
        let(:cache_name) { "test_cache" }
        it { expect(subject).to be_a_kind_of(cache_config_class) }
      end
    end
    context "when invoked with an unknown cache" do
      subject { Butterfli::Configuration::Caches.instantiate_cache(:unknown_cache) }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end