require 'spec_helper'

describe Butterfli::Cache do
  let(:adapter) { double('adapter') }
  let(:cache) { Butterfli::Cache.new(adapter) }

  context "when initialized" do
    it { expect(cache.adapter).to eq(adapter) }
  end
  context "#read" do
    subject { cache.read(key) }
    let(:key) { "key" }
    it { expect(adapter).to receive(:read).with(key).exactly(1).times; subject }
  end
  context "#write" do
    subject { cache.write(key, value) }
    let(:key) { "key" }
    let(:value) { "value" }
    it { expect(adapter).to receive(:write).with(key, value).exactly(1).times; subject }
  end
  context "#fetch" do
    subject { cache.fetch(key, value) }
    let(:key) { "key" }
    let(:value) { "value" }
    it { expect(adapter).to receive(:fetch).with(key, value).exactly(1).times; subject }
  end
  context "#lazy_fetch" do
    subject { cache.lazy_fetch(key, &value_block) }
    let(:key) { "key" }
    let(:value_block) { Proc.new { "block value" } }
    # Rspec is kind of dumb: it doesn't know how to expect block arguments
    it { expect(adapter).to receive(:lazy_fetch).with(key).exactly(1).times; subject }
  end
  context "#delete" do
    subject { cache.delete(key) }
    let(:key) { "key" }
    it { expect(adapter).to receive(:delete).with(key).exactly(1).times; subject }
  end
  context "#clear" do
    subject { cache.clear }
    it { expect(adapter).to receive(:clear).exactly(1).times; subject }
  end
  context "#has_key?" do
    subject { cache.has_key?(key) }
    let(:key) { "key" }
    it { expect(adapter).to receive(:has_key?).with(key).exactly(1).times; subject }
  end
  context "#empty?" do
    subject { cache.empty? }
    it { expect(adapter).to receive(:empty?).exactly(1).times; subject }
  end
end