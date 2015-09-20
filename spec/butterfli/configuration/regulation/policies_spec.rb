require 'spec_helper'

describe Butterfli::Configuration::Regulation::Policies do
  subject { Butterfli::Configuration::Regulation::Policies }

  describe "#known_policies" do
    subject { super().known_policies }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_policy" do
    subject { super().register_policy(policy_name, policy_class) }

    # Create fake policy to drive tests
    let(:policy_name) { :test_policy }
    let(:policy_class) do
      stub_const 'TestPolicy', Class.new(Butterfli::Configuration::Regulation::Policy)
      TestPolicy
    end

    context "when invoked with a policy name and class" do
      it do
        expect(subject).to eq(policy_class)
        expect(Butterfli::Configuration::Regulation::Policies.known_policies).to include(policy_name)
      end
    end
  end

  describe "#instantiate_policy" do
    subject { super().instantiate_policy(policy_name) }

    # Create fake policy to drive tests
    let(:policy_class) do
      stub_const 'TestPolicy', Class.new(Butterfli::Configuration::Regulation::Policy)
      TestPolicy
    end
    before { Butterfli::Configuration::Regulation::Policies.register_policy(:test_policy, policy_class) }

    context "when invoked with a known policy" do
      context "(as a Symbol)" do
        let(:policy_name) { :test_policy }
        it { expect(subject).to be_a_kind_of(policy_class) }
      end
      context "(as a String)" do
        let(:policy_name) { "test_policy" }
        it { expect(subject).to be_a_kind_of(policy_class) }
      end
    end
    context "when invoked with an unknown policy" do
      let(:policy_name) { :unknown_policy }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end