require 'spec_helper'

describe Butterfli::Configuration::SyndicateWriter do
  context "when configured within Butterfli" do
    let(:write_error_block) { Proc.new { } }
    before do
      Butterfli.writers = nil
      Butterfli.configure do |config|
        config.writer :syndicate do |writer|
          writer.on_write_error &write_error_block
        end
      end
    end
    after { Butterfli.writers = nil; Butterfli.configure { } }
    subject { Butterfli.writers.first }
    it do
      expect(subject).to be_a_kind_of(Butterfli::SyndicateWriter)
      expect(subject.write_error_block).to eq(write_error_block)
    end
  end
end