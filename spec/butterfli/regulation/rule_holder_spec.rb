require 'spec_helper'

describe Butterfli::Regulation::RuleHolder do
  let(:rule_holder_class) do
    stub_const 'RuleHolderClass', Class.new
    RuleHolderClass.class_eval { include Butterfli::Regulation::RuleHolder }
    RuleHolderClass
  end
  let(:rule_holder) { rule_holder_class.new }
  let(:rule_class) do
    stub_const 'TestRule', Class.new
    TestRule.class_eval { include Butterfli::Regulation::Rule }
    TestRule
  end

  describe "#rules" do
    subject { rule_holder.rules }
    context "when no rules have been added" do
      it { expect(subject).to be_empty }
    end
    context "when a rule has been added" do
      let(:rule) { double('rule') }
      before(:each) { rule_holder.add_rules(rule) }
      it { expect(subject).to include(rule) }
    end
  end

  describe "#permits?" do
    subject { rule_holder.permits?(item) }
    let(:item) { 1 }
    context "when there are no rules" do
      it { expect(subject).to be true }
    end
    context "when a rule is defined" do
      let(:rule) { rule_class.new }
      before(:each) { rule_holder.add_rules(rule) }
      context "that doesn't apply" do
        before(:each) do
          rule.class.applies_if { false }
          rule.class.permits_if { item != item }
        end
        it { expect(subject).to be true }
      end
      context "that applies" do
        before(:each) { rule.class.applies_if { true } }
        context "but whose conditions don't match" do
          before(:each) { rule.class.permits_if { false } }
          it { expect(subject).to be false }
        end
        context "and whose conditions match" do
          before(:each) { rule.class.permits_if { true } }
          it { expect(subject).to be true }
        end
      end
    end
    context "when multiple rules exist" do
      let(:rule) { rule_class.new }
      let(:rule_two_class) do
        stub_const 'TestRuleTwo', Class.new
        TestRuleTwo.class_eval { include Butterfli::Regulation::Rule }
        TestRuleTwo
      end
      let(:rule_two) { rule_two_class.new }
      before(:each) { rule_holder.add_rules(rule, rule_two) }
      context "of which all apply" do
        before(:each) do
          [rule.class, rule_two.class].each { |c| c.applies_if { true } }
        end
        context "but only one doesn't match" do
          before(:each) { rule_two.class.permits_if { false } }
          it { expect(subject).to be false }
        end
      end
    end
  end
end