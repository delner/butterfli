require 'spec_helper'

describe Butterfli::Processor::Base do
  let(:options) { {} }
  let(:processor) { Butterfli::Processor::Base.new(options) }

  context "when initialized" do
    context "with writers" do
      let(:writers) { [Butterfli::Writer.new] }
      let(:options) { { writers: writers } }
      it { expect(processor.writers).to eq(writers) }
    end
  end
  context "#writers" do
    subject { processor.writers }
    context "when none were added" do
      it { expect(subject).to be_empty }
    end
  end
end