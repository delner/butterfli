require 'spec_helper'

describe Butterfli::Configuration::Processing::Processors do
  subject { Butterfli::Configuration::Processing::Processors }

  # Create fake processor to drive tests
  let(:processor_name) { :test_processor }
  let(:processor_config_class) do
    stub_const 'TestProcessorConfig', Class.new(Butterfli::Configuration::Processing::Processor)
    TestProcessorConfig
  end

  describe "#known_processors" do
    subject { super().known_processors }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_processor" do
    subject { super().register_processor(processor_name, processor_config_class) }

    context "when invoked with a processor name and class" do
      it do
        expect(subject).to eq(processor_config_class)
        expect(Butterfli::Configuration::Processing::Processors.known_processors).to include(processor_name)
      end
    end
  end

  describe "#instantiate_processor" do
    before { Butterfli::Configuration::Processing::Processors.register_processor(processor_name, processor_config_class) }

    subject { super().instantiate_processor(processor_name) }

    context "when invoked with a known processor" do
      context "(as a Symbol)" do
        let(:processor_name) { :test_processor }
        it { expect(subject).to be_a_kind_of(processor_config_class) }
      end
      context "(as a String)" do
        let(:processor_name) { "test_processor" }
        it { expect(subject).to be_a_kind_of(processor_config_class) }
      end
    end
    context "when invoked with an unknown processor" do
      subject { Butterfli::Configuration::Processing::Processors.instantiate_processor(:unknown_processor) }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end