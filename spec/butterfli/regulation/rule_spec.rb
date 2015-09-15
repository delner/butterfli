require 'spec_helper'

describe Butterfli::Regulation::Rule do
  let(:rule_class) do
    stub_const 'TestRule', Class.new
    TestRule.class_eval { include Butterfli::Regulation::Rule }
    TestRule
  end
  describe "class method" do
    describe "#applies_if" do
      subject { rule_class.applies_if &block }
      context "when given a block" do
        let(:block) { Proc.new { } }
        it { subject; expect(rule_class.matchers.first.block).to eq(block) }
      end
    end
    describe "#matchers" do
      subject { rule_class.matchers }
      context "when no matchers have been added" do
        it { expect(subject).to be_empty }
      end
      context "when a matcher has been added" do
        let(:block) { Proc.new { } }
        before(:each) { rule_class.applies_if &block }
        it { expect(subject).to have_exactly(1).items }
        it { expect(subject.first).to be_a_kind_of(Butterfli::Regulation::Rule::Matcher) }
      end
    end
    describe "#permits_if" do
      subject { rule_class.permits_if &block }
      context "when given a block" do
        let(:block) { Proc.new { } }
        it { subject; expect(rule_class.conditions.first.block).to eq(block) }
      end
    end
    describe "#conditions" do
      subject { rule_class.conditions }
      context "when no conditions have been added" do
        it { expect(subject).to be_empty }
      end
      context "when a condition has been added" do
        let(:block) { Proc.new { } }
        before(:each) { rule_class.permits_if &block }
        it { expect(subject).to have_exactly(1).items }
        it { expect(subject.first).to be_a_kind_of(Butterfli::Regulation::Rule::Condition) }
      end
    end
    describe "#fact" do
      subject { rule_class.fact name, &block }
      context "when given a name and a block" do
        let(:name) { :fact }
        let(:block) { Proc.new { } }
        it { subject; expect(rule_class.facts[name].block).to eq(block) }
      end
    end
    describe "#facts" do
      subject { rule_class.facts }
      context "when no facts have been added" do
        it { expect(subject).to be_empty }
      end
      context "when a fact has been added" do
        let(:name) { :fact }
        let(:block) { Proc.new { } }
        before(:each) { rule_class.fact name, &block }
        it { expect(subject).to have_exactly(1).items }
        it { expect(subject[name]).to be_a_kind_of(Butterfli::Regulation::Rule::Fact) }
      end
    end
  end

  describe "instance method" do
    let(:rule) { rule_class.new }
    describe "#applies_to?" do
      let(:item) { 1 }
      subject { rule.applies_to?(item) }
      context "when no matchers have been defined" do
        it { expect(subject).to be false }
      end
      context "when a matcher" do
        before(:each) { rule.class.applies_if(&matcher) }
        context "that matches the item is defined" do
          let(:matcher) { Proc.new { item == item } }
          it { expect(subject).to be true }
          context "and another that matches is defined" do
            let(:matcher_two) { Proc.new { item == item } }
            before(:each) { rule.class.applies_if(&matcher_two) }
            it { expect(subject).to be true }
          end
          context "and another that doesn't match is defined" do
            let(:matcher_two) { Proc.new { item != item } }
            before(:each) { rule.class.applies_if(&matcher_two) }
            it { expect(subject).to be false }
          end
        end
        context "that doesn't match the item is defined" do
          let(:matcher) { Proc.new { item != item } }
          it { expect(subject).to be false }
          context "and another that doesn't match is defined" do
            let(:matcher_two) { Proc.new { item != item } }
            before(:each) { rule.class.applies_if(&matcher_two) }
            it { expect(subject).to be false }
          end
        end
      end
    end
    describe "#permits?" do
      let(:item) { 1 }
      subject { rule.permits?(item) }

      context "when the rule applies" do
        before(:each) { rule.class.applies_if(&(Proc.new { true })) }
        context "when no conditions have been defined" do
          it { expect(subject).to be true }
        end
        context "and a condition" do
          before(:each) { rule.class.permits_if(&condition) }
          context "that matches the item is defined" do
            let(:condition) { Proc.new { item == item } }
            it { expect(subject).to be true }
            context "and another that matches is defined" do
              let(:condition_two) { Proc.new { item == item } }
              before(:each) { rule.class.permits_if(&condition_two) }
              it { expect(subject).to be true }
            end
            context "and another that doesn't match is defined" do
              let(:condition_two) { Proc.new { item != item } }
              before(:each) { rule.class.permits_if(&condition_two) }
              it { expect(subject).to be false }
            end
          end
          context "that doesn't match the item is defined" do
            let(:condition) { Proc.new { item != item } }
            it { expect(subject).to be false }
            context "and another that doesn't match is defined" do
              let(:condition_two) { Proc.new { item != item } }
              before(:each) { rule.class.permits_if(&condition_two) }
              it { expect(subject).to be false }
            end
          end
        end
      end
      context "when the rule doesn't apply" do
        before(:each) { rule.class.applies_if(&(Proc.new { false })) }
        context "when no conditions have been defined" do
          # True because #permits? doesn't care whether rule applies
          it { expect(subject).to be true }
        end
        context "and a condition" do
          before(:each) { rule.class.permits_if(&condition) }
          context "that matches the item is defined" do
            let(:condition) { Proc.new { item == item } }
            # True because #permits? doesn't care whether rule applies
            it { expect(subject).to be true }
          end
        end
      end
    end
    describe "#fact" do
      subject { rule.fact(name) }
      context "when given a name" do
        let(:name) { :fact }
        context "of a defined fact" do
          before(:each) { rule.class.fact(name, &(Proc.new { name })) }
          it { expect(subject).to be_a_kind_of(Butterfli::Regulation::Rule::Fact) }
        end
        context "of an undefined fact" do
          it { expect { subject }.to raise_error(KeyError) }
        end
      end
    end
  end

  context "when inherited by a class with matchers/conditions/facts" do
    let(:fact_name) { :fact }
    before(:each) do
      rule_class.applies_if(&(Proc.new { true }))
      rule_class.permits_if(&(Proc.new { true }))
      rule_class.fact(fact_name, &(Proc.new { true }))
    end
    subject { rule_class }
    it { expect(subject.matchers).to have_exactly(1).items }
    it { expect(subject.conditions).to have_exactly(1).items }
    it { expect(subject.facts).to have_exactly(1).items }

    context "whom is then inherited by another class" do
      let(:grandchild_class) do
        stub_const 'GranchildRule', Class.new(rule_class)
        GranchildRule
      end
      subject { grandchild_class }
      context "that defines a matcher" do
        before(:each) { grandchild_class.applies_if(&(Proc.new { true })) }
        it { expect(subject.matchers).to have_exactly(2).items }
      end
      context "that defines a condition" do
        before(:each) { grandchild_class.permits_if(&(Proc.new { true })) }
        it { expect(subject.conditions).to have_exactly(2).items }
      end
      context "that defines a fact" do
        let(:grandchild_fact_name) { :grandchild_fact }
        before(:each) { grandchild_class.fact(grandchild_fact_name, &(Proc.new { true })) }
        it { expect(subject.facts).to have_exactly(2).items }
      end
    end
  end
end