require 'spec_helper'

describe Butterfli::Configuration::Regulation::PolicyHolder do
  let(:policy_holder_class) do
    stub_const 'ProviderConfig', Class.new
    ProviderConfig.class_eval { include Butterfli::Configuration::Regulation::PolicyHolder }
    ProviderConfig
  end
  let(:policy_holder) { policy_holder_class.new }

  describe "#policies" do
    subject { policy_holder.policies }
    context "when no policies have been added" do
      it { expect(subject).to be_empty }
    end
    context "when policies have been added" do
      let(:policy) { double('policy') }
      let(:policy_name) { :policy }
      before(:each) { policy_holder.policies[policy_name] = policy }
      it { expect(subject).to include(policy_name) }
    end
  end
  describe "#policy" do
    context "when given a name and block" do
      let(:target) { double('target') }
      let(:block) { Proc.new { |t| target.configure(t) } }
      let(:name) { :test }
      let(:policy_class) { double('policy_class') }
      let(:policy_object) { double('policy_object') }

      before(:each) do
        allow(policy_class).to receive(:new).and_return(policy_object)
        Butterfli::Configuration::Regulation::Policies.register_policy(name, policy_class)
      end
      after(:each) { Butterfli::Configuration::Regulation::Policies.known_policies.clear }

      subject { policy_holder.policy name, &block }

      it do
        expect(target).to receive(:configure).with(policy_object)
        subject
        expect(policy_holder.policies).to include(name)
      end
    end
  end
  describe "#policies" do
    subject { policy_holder.policies }
    context "when no policies have been added" do
      it { expect(subject).to be_empty }
    end
  end
end