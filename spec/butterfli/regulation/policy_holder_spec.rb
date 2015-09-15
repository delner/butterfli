require 'spec_helper'

describe Butterfli::Regulation::PolicyHolder do
  let(:policy_holder_class) do
    stub_const 'PolicyHolderClass', Class.new
    PolicyHolderClass.class_eval { include Butterfli::Regulation::PolicyHolder }
    PolicyHolderClass
  end
  let(:policy_holder) { policy_holder_class.new }

  describe "#policies" do
    subject { policy_holder.policies }
    context "when no policies have been added" do
      it { expect(subject).to be_empty }
    end
    context "when a policy has been added" do
      let(:policy_name) { :policy_one }
      let(:policy) { double('policy') }
      before(:each) { policy_holder.add_policy(policy_name, policy) }
      it { expect(subject).to include(policy_name) }
    end
  end
end