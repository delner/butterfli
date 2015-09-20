require 'spec_helper'

describe Butterfli::Regulation::Rule::Fact do
  let(:fact) { Butterfli::Regulation::Rule::Fact.new(&block) }
  describe "when instantiated" do
    subject { fact }
    context "with a block" do
      let(:block) { Proc.new { } }
      it { expect(subject.block).to eq(block) }
    end
  end
  describe "#from" do
    context "when given arguments" do
      let(:target) { double('target') }
      let(:block) { Proc.new { |one, two| target.called(one, two) } }
      let(:args) { [1, 2] }
      subject { fact.from(*args) }
      it { expect(target).to receive(:called).with(*args); subject }
    end
  end
  describe "#read" do
    context "when given arguments" do
      let(:target) { double('target') }
      let(:block) { Proc.new { target.called } }
      subject { fact.read }
      it { expect(target).to receive(:called); subject }
    end
  end
end