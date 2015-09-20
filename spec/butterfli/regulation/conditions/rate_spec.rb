require 'spec_helper'

describe Butterfli::Regulation::Conditions::Rate do
  let(:rule_class) do
    stub_const 'TestRule', Class.new
    TestRule.class_eval { include Butterfli::Regulation::Conditions::Rate }
    TestRule
  end
  # Always force rule to apply, to test condition
  before(:each) { rule_class.applies_if(&(Proc.new { true })) }
  let(:rule) { rule_class.new }

  describe "#max" do
    it { expect(rule).to respond_to(:max) }
    it { expect(rule).to respond_to(:max=) }
  end
  describe "#interval" do
    it { expect(rule).to respond_to(:interval) }
    it { expect(rule).to respond_to(:interval=) }
  end
  describe "#effective_rate" do
    subject { rule.effective_rate }
    before do
      rule.max = max
      rule.interval = interval
    end
    let(:max) { 400 }
    let(:interval) { 60 }
    it { expect(subject).to eq(max.to_f/interval.to_f) }
  end
  describe "#seconds_per" do
    subject { rule.seconds_per }
    before do
      rule.max = max
      rule.interval = interval
    end
    let(:max) { 60 }
    let(:interval) { 400 }
    it { expect(subject).to eq(interval.to_f/max.to_f) }
  end
  describe "#permits?" do
    subject { rule.permits?(item) }
    let(:target) { double('target') }
    let(:item) { 1 }
    before(:each) do
      rule.max = max
      rule.interval = interval
      rule.class.fact :last_time do |rule, item|
        target.last_time(rule, item)
      end
      allow(target).to receive(:last_time).with(Butterfli::Regulation::Rule, Object).and_return(last_time)
    end
    context "when the rate has not been exceeded" do
      let(:last_time) { Time.now - 120 }
      let(:max) { 1 }
      let(:interval) { 60 }
      it do
        expect(target).to receive(:last_time).with(rule, item)
        expect(subject).to be true
      end
    end
    context "when the rate has been exceeded" do
      let(:last_time) { Time.now - 30 }
      let(:max) { 1 }
      let(:interval) { 60 }
      it do
        expect(target).to receive(:last_time).with(rule, item)
        expect(subject).to be false
      end
    end
  end
end