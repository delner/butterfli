require 'spec_helper'

describe Butterfli::Regulation::Rule::Condition do
  let(:condition) { Butterfli::Regulation::Rule::Condition.new(&block) }
  describe "when instantiated" do
    subject { condition }
    context "with a block" do
      let(:block) { Proc.new { } }
      it { expect(subject.block).to eq(block) }
    end
  end
  describe "#call" do
    context "when given arguments" do
      let(:target) { double('target') }
      let(:block) { Proc.new { |one, two| target.called(one, two) } }
      let(:args) { [1, 2] }
      subject { condition.call(*args) }
      it { expect(target).to receive(:called).with(*args); subject }
    end
  end
end