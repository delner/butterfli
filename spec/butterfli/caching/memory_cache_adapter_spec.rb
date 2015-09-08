require 'spec_helper'

describe Butterfli::Cache do
  let(:adapter) { Butterfli::MemoryCacheAdapter.new }
  let(:memory_cache) { adapter.memory_cache }

  context "when initialized" do
    it { expect(memory_cache).to eq({}) }
  end
  context "#read" do
    subject { adapter.read(key) }
    let(:key) { "key" }
    context "when the key exists in the cache" do
      let(:value) { "value" }
      before(:each) { adapter.write(key, value) }
      it { expect(subject).to eq(value) }
    end
    context "when the key doesn't exists in the cache" do
      it { expect(subject).to be nil }
    end
  end
  context "#write" do
    subject { adapter.write(key, value) }
    let(:key) { "key" }
    let(:value) { "value" }
    it do
      expect(subject).to eq(value)
      expect(adapter.read(key)).to eq(value)
    end
  end
  context "#fetch" do
    let(:key) { "key" }
    let(:value) { "value" }
    let(:block_value) { "block value" }
    let(:block) { Proc.new { block_value } }

    context "invoked against existing key" do
      let(:old_value) { "old_value" }
      before(:each) { adapter.write(key, old_value) }
      subject { adapter.fetch(key, value) }
      it { expect(subject).to eq(old_value) }
    end
    context "invoked against non-existent key" do
      context "when passed a value" do
        subject { adapter.fetch(key, value) }
        it { expect(subject).to eq(value) }
      end
      context "when passed a block" do
        subject { adapter.fetch(key, &block) }
        it { expect(subject).to eq(block_value) }
      end
      context "when passed a value and block" do
        subject { adapter.fetch(key, value, &block) }
        it { expect(subject).to eq(value) }
      end
    end
  end
  context "#delete" do
    subject { adapter.delete(key) }
    let(:key) { "key" }
    let(:old_value) { "old_value" }
    before(:each) { adapter.write(key, old_value) }
    it do
      expect(subject).to eq(old_value)
      expect(adapter.has_key?(key)).to be false
    end
  end
  context "#clear" do
    subject { adapter.clear }
    let(:key) { "key" }
    let(:old_value) { "old_value" }
    before(:each) { adapter.write(key, old_value) }
    it do
      expect(subject).to eq({})
      expect(adapter.empty?).to be true
    end
  end
  context "#has_key?" do
    subject { adapter.has_key?(key) }
    let(:key) { "key" }
    context "invoked against existing key" do
      before(:each) { adapter.write(key, 1) }
      it { expect(subject).to be true }
    end
    context "invoked against non-existent key" do
      it { expect(subject).to be false }
    end
  end
  context "#empty?" do
    subject { adapter.empty? }
    context "invoked against non-empty cache" do
      before(:each) { adapter.write("key", "value") }
      it { expect(subject).to be false }
    end
    context "invoked against empty cache" do
      it { expect(subject).to be true }
    end
  end
end