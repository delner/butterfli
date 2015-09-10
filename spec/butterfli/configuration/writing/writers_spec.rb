require 'spec_helper'

describe Butterfli::Configuration::Writing::Writers do
  subject { Butterfli::Configuration::Writing::Writers }

  # Create fake writer to drive tests
  let(:writer_name) { :test_writer }
  let(:writer_config_class) do
    stub_const 'TestWriterConfig', Class.new(Butterfli::Configuration::Writing::Writer)
    TestWriterConfig
  end
  let(:writer_class) do
    stub_const 'TestWriter', Class.new(Butterfli::Writing::Writer)
    TestWriter
  end

  describe "#known_writers" do
    subject { super().known_writers }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
    end
  end

  describe "#register_writer" do
    subject { super().register_writer(writer_name, writer_config_class) }

    context "when invoked with a writer name and class" do
      it do
        expect(subject).to eq(writer_config_class)
        expect(Butterfli::Configuration::Writing::Writers.known_writers).to include(writer_name)
      end
    end
  end

  describe "#instantiate_writer" do
    before { Butterfli::Configuration::Writing::Writers.register_writer(writer_name, writer_config_class) }

    subject { super().instantiate_writer(writer_name) }

    context "when invoked with a known writer" do
      context "(as a Symbol)" do
        let(:writer_name) { :test_writer }
        it { expect(subject).to be_a_kind_of(writer_config_class) }
      end
      context "(as a String)" do
        let(:writer_name) { "test_writer" }
        it { expect(subject).to be_a_kind_of(writer_config_class) }
      end
    end
    context "when invoked with an unknown writer" do
      subject { Butterfli::Configuration::Writing::Writers.instantiate_writer(:unknown_writer) }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end