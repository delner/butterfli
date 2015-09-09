require 'spec_helper'

describe Butterfli::Configuration::Writers do
  subject { Butterfli::Configuration::Writers }

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
    subject { super().register_writer(writer_name, writer_config_class, writer_class) }

    context "when invoked with a writer name and class" do
      it do
        expect(subject).to eq({ configuration: writer_config_class, instance: writer_class})
        expect(Butterfli::Configuration::Writers.known_writers).to include(writer_name)
      end
    end
  end

  describe "#instantiate_writer" do
    before { Butterfli::Configuration::Writers.register_writer(writer_name, writer_config_class, writer_class) }

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
      subject { Butterfli::Configuration::Writers.instantiate_writer(:unknown_writer) }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end