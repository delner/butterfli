require 'spec_helper'

describe Butterfli::Regulation::Rule::Matcher do
  let(:matcher) { Butterfli::Regulation::Rule::Matcher.new(&block) }
  describe "when instantiated" do
    subject { matcher }
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
      subject { matcher.call(*args) }
      it { expect(target).to receive(:called).with(*args); subject }
    end
  end
end