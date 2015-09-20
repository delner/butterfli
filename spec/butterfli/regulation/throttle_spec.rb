require 'spec_helper'

describe Butterfli::Regulation::Throttle do
  it { expect(Butterfli::Regulation::Throttle <= Butterfli::Regulation::Rule).to be true }
  it { expect(Butterfli::Regulation::Throttle <= Butterfli::Regulation::Conditions::Rate).to be true }
  context "when initialized" do
    context "with a max" do
      subject { Butterfli::Regulation::Throttle.new(max: max) }
      let(:max) { 1 }
      it { expect(subject.max).to eq(max) }
    end
    context "with an interval" do
      subject { Butterfli::Regulation::Throttle.new(interval: interval) }
      let(:interval) { 60 }
      it { expect(subject.interval).to eq(interval) }
    end
  end
end