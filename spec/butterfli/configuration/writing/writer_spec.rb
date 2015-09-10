require 'spec_helper'

describe Butterfli::Configuration::Writing::Writer do
  let(:writer) { Butterfli::Configuration::Writing::Writer.new }
  subject { writer }

  context "#on_write_error" do
    it { expect(writer).to respond_to(:on_write_error) }
    context "when given a block" do
      let(:write_error_block) { Proc.new { } }
      subject { writer.on_write_error &write_error_block }
      it { subject; expect(writer.write_error_block).to eq(write_error_block) }
    end
  end
end