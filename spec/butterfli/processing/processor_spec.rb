require 'spec_helper'

describe Butterfli::Processing::Processor do
  let(:adapter) { double('adapter') }
  let(:processor) { Butterfli::Processing::Processor.new(adapter) }

  context "when initialized" do
    it { expect(processor.adapter).to eq(adapter) }
  end
  context "#enqueue" do
    subject { processor.enqueue(queue, job) }
    let(:queue) { "queue" }
    let(:job) { "job" }
    it { expect(adapter).to receive(:enqueue).with(queue, job).exactly(1).times; subject }
  end
  context "#dequeue" do
    subject { processor.dequeue(queue) }
    let(:queue) { "queue" }
    it { expect(adapter).to receive(:dequeue).with(queue).exactly(1).times; subject }
  end
end