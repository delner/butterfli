require 'spec_helper'

describe Butterfli::Regulation::Matchers::Type do
  let(:rule_class) do
    stub_const 'TestRule', Class.new
    TestRule.class_eval { include Butterfli::Regulation::Matchers::Type }
    TestRule
  end
  let(:rule) { rule_class.new }

  describe "#type" do
    it { expect(rule).to respond_to(:type) }
    it { expect(rule).to respond_to(:type=) }
  end
  describe "#applies_to?" do
    subject { rule.applies_to?(item) }
    let(:item) { 1 }
    before(:each) { rule.type = type }
    context "when the item is of type" do
      let(:type) { Fixnum }
      it { expect(subject).to be true }
    end
    context "when the item is of descendant type" do
      let(:type) { Integer }
      it { expect(subject).to be true }
    end
    context "when the item is not of type" do
      let(:type) { String }
      it { expect(subject).to be false }
    end
  end
end