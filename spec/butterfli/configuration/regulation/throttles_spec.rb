require 'spec_helper'

describe Butterfli::Configuration::Regulation::Throttles do
  subject { Butterfli::Configuration::Regulation::Throttles }

  describe "#known_throttles" do
    subject { super().known_throttles }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_throttle" do
    subject { super().register_throttle(throttle_name, throttle_class) }

    # Create fake throttle to drive tests
    let(:throttle_name) { :test_throttle }
    let(:throttle_class) do
      stub_const 'TestThrottle', Class.new(Butterfli::Configuration::Regulation::Throttle)
      TestThrottle
    end

    context "when invoked with a throttle name and class" do
      it do
        expect(subject).to eq(throttle_class)
        expect(Butterfli::Configuration::Regulation::Throttles.known_throttles).to include(throttle_name)
      end
    end
  end

  describe "#instantiate_throttle" do
    subject { super().instantiate_throttle(throttle_name) }

    # Create fake throttle to drive tests
    let(:throttle_class) do
      stub_const 'TestThrottle', Class.new(Butterfli::Configuration::Regulation::Throttle)
      TestThrottle
    end
    before { Butterfli::Configuration::Regulation::Throttles.register_throttle(:test_throttle, throttle_class) }

    context "when invoked with a known throttle" do
      context "(as a Symbol)" do
        let(:throttle_name) { :test_throttle }
        it { expect(subject).to be_a_kind_of(throttle_class) }
      end
      context "(as a String)" do
        let(:throttle_name) { "test_throttle" }
        it { expect(subject).to be_a_kind_of(throttle_class) }
      end
    end
    context "when invoked with an unknown throttle" do
      let(:throttle_name) { :unknown_throttle }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end