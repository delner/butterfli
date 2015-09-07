require 'spec_helper'

describe Butterfli::Configuration::Processor do
  let(:processor) { Butterfli::Configuration::Processor.new }
  subject { processor }

  context "#writer" do
    it { expect(subject).to respond_to(:writer) }
  end
  context "#writers" do
    subject { processor.writers }

    it { expect(processor).to respond_to(:writers) }
    context "when no writers have been added" do
      it { expect(subject).to be_empty }
    end
  end
end