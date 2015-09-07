require 'spec_helper'

describe Butterfli::Configuration::Processors do
  subject { Butterfli::Configuration::Processors }

  describe "#known_processors" do
    subject { super().known_processors }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_processor" do
    subject { super().register_processor(processor_name, processor_class) }

    # Create fake processor to drive tests
    let(:processor_name) { :test_processor }
    let(:processor_class) do
      stub_const 'TestProcessor', Class.new(Butterfli::Configuration::Processor)
      TestProcessor
    end

    context "when invoked with a processor name and class" do
      it do
        expect(subject).to eq(processor_class)
        expect(Butterfli::Configuration::Processors.known_processors).to include(processor_name)
      end
    end
  end

  describe "#instantiate_processor" do
    subject { super().instantiate_processor(processor_name) }

    # Create fake processor to drive tests
    let(:processor_class) do
      stub_const 'TestProcessor', Class.new(Butterfli::Configuration::Processor)
      TestProcessor
    end
    before { Butterfli::Configuration::Processors.register_processor(:test_processor, processor_class) }

    context "when invoked with a known processor" do
      context "(as a Symbol)" do
        let(:processor_name) { :test_processor }
        it { expect(subject).to be_a_kind_of(processor_class) }
      end
      context "(as a String)" do
        let(:processor_name) { "test_processor" }
        it { expect(subject).to be_a_kind_of(processor_class) }
      end
    end
    context "when invoked with an unknown processor" do
      let(:processor_name) { :unknown_processor }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end