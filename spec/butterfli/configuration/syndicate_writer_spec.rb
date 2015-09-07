require 'spec_helper'

describe Butterfli::Configuration::SyndicateWriter do
  context "when configured within a processor in Butterfli" do
    let(:write_error_block) { Proc.new { } }
    before do
      Butterfli.processor = nil
      Butterfli.configure do |config|
        config.processor :monolith do |processor|
          processor.writer :syndicate do |writer|
            writer.on_write_error &write_error_block
          end
        end
      end
    end
    after { Butterfli.processor = nil; Butterfli.configure { } }
    subject { Butterfli.processor.writers.first }
    it do
      expect(subject).to be_a_kind_of(Butterfli::SyndicateWriter)
      expect(subject.write_error_block).to eq(write_error_block)
    end
  end
end