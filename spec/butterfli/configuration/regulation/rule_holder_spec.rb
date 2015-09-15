require 'spec_helper'

describe Butterfli::Configuration::Regulation::RuleHolder do
  let(:regulated_class) do
    stub_const 'ProviderConfig', Class.new
    ProviderConfig.class_eval { include Butterfli::Configuration::Regulation::RuleHolder }
    ProviderConfig
  end
  let(:regulated_object) { regulated_class.new }

  describe "#rules" do
    subject { regulated_object.rules }
    context "when no rules have been added" do
      it { expect(subject).to be_empty }
    end
    context "when rules have been added" do
      let(:throttle) { double('throttle') }
      before(:each) { regulated_object.throttles << throttle }
      it { expect(subject).to include(throttle) }
    end
  end
  describe "#throttle" do
    context "when given a name and block" do
      let(:target) { double('target') }
      let(:block) { Proc.new { |t| target.configure(t) } }
      let(:name) { :test }
      let(:throttle_class) { double('throttle_class') }
      let(:throttle_object) { double('throttle_object') }

      before(:each) do
        allow(throttle_class).to receive(:new).and_return(throttle_object)
        Butterfli::Configuration::Regulation::Throttles.register_throttle(name, throttle_class)
      end
      after(:each) { Butterfli::Configuration::Regulation::Throttles.known_throttles.clear }

      subject { regulated_object.throttle name, &block }

      it do
        expect(target).to receive(:configure).with(throttle_object)
        subject
        expect(regulated_object.throttles).to include(throttle_object)
      end
    end
  end
  describe "#throttles" do
    subject { regulated_object.throttles }
    context "when no throttles have been added" do
      it { expect(subject).to be_empty }
    end
  end
end