require 'spec_helper'

describe Butterfli::Configuration::Regulation::Throttle do
  let(:throttle) { Butterfli::Configuration::Regulation::Throttle.new }
  subject { throttle }

  context "#limit" do
    it { expect(throttle).to respond_to(:limit) }
    it { expect(throttle).to respond_to(:max) }
    context "when given a block" do
      let(:limit) { 100 }
      subject { throttle.limit limit }
      it { subject; expect(throttle.max).to eq(limit) }
    end
  end
  context "#per_seconds" do
    it { expect(throttle).to respond_to(:per_seconds) }
    it { expect(throttle).to respond_to(:interval) }
    context "when given a block" do
      let(:seconds) { 100 }
      subject { throttle.per_seconds seconds }
      it { subject; expect(throttle.interval).to eq(seconds) }
    end
  end
end