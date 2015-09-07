require 'spec_helper'

describe Butterfli::Writer do
  let(:writer_class) do
    stub_const 'TestWriter', Class.new(Butterfli::Writer)
    # NOTE: We add this #set_write_block because class definitions cannot access Rspec variables (out of scope)
    TestWriter.send :define_method, :set_write_block do |&block| instance_variable_set(:@write_block, block) end
    TestWriter.send :define_method, :write do |stories| instance_variable_get(:@write_block).call(stories) end
    TestWriter
  end
  let(:options) { {} }
  let(:writer) { writer_class.new(options) }

  context "when instantiated" do
    subject { writer }
    context "with no arguments" do
      it { expect(subject.write_error_block).to be_nil }
    end
    context "with :write_error_block" do
      let(:write_error_block) { Proc.new { } }
      let(:options) { { write_error_block: write_error_block } }
      it { expect(subject.write_error_block).to eq(write_error_block) }
    end
  end
  context "#write_with_error_handling" do
    context "when #write" do
      let(:target) { double('target') }
      let(:stories) { [Butterfli::Story.new] }
      subject { writer.write_with_error_handling(stories) }

      # Manually set the write block before each example
      before(:each) { writer.set_write_block(&write_block) }

      context "returns successfully" do
        let(:write_block) { Proc.new { |stories| target.write(stories) } }
        it do
          expect(target).to receive(:write).with(stories).exactly(1).times
          expect(subject).to be true
        end
      end
      context "raises a StandardError" do
        let(:write_block) { Proc.new { |stories| target.write(stories); raise "This writer was destined to fail." } }
        context "and no write_error_block is defined" do
          it do
            expect(target).to receive(:write).with(stories).exactly(1).times
            expect(subject).to be false
          end
        end
        context "and a write_error_block is defined" do
          let(:options) { { write_error_block: write_error_block } }
          context "which returns successfully" do
            let(:custom_return_value) { "Error handled." }
            let(:write_error_block) { Proc.new { |error, stories| target.error(error, stories); custom_return_value } }
            it do
              expect(target).to receive(:write).with(stories).exactly(1).times
              expect(target).to receive(:error).with(StandardError, stories).exactly(1).times
              expect(subject).to be custom_return_value
            end
          end
          context "which raises a StandardError" do
            let(:write_error_block) { Proc.new { |error, stories| target.error(error, stories); raise "This error handler was destined to fail." } }
            it do
              expect(target).to receive(:write).with(stories).exactly(1).times
              expect(target).to receive(:error).with(StandardError, stories).exactly(1).times
              expect(subject).to be false
            end
          end
        end
      end
      context "raises an Exception" do
        let(:write_block) { Proc.new { target.write(stories); raise Exception, "Red alert, red alert! It's a catastrophe!" } }
        context "and no write_error_block is defined" do
          it do
            expect(target).to receive(:write).with(stories).exactly(1).times
            expect { subject }.to raise_exception(Exception)
          end
        end
        context "and a write_error_block is defined" do
          let(:options) { { write_error_block: write_error_block } }
          context "which returns successfully" do
            let(:write_error_block) { Proc.new { |error, stories| target.error(error, stories) } }
            it do
              expect(target).to receive(:write).with(stories).exactly(1).times
              expect(target).to receive(:error).with(Exception, stories).exactly(1).times
              expect { subject }.to raise_exception(Exception)
            end
          end
          context "which raises a StandardError" do
            let(:write_error_block) { Proc.new { |error, stories| target.error(error, stories); raise "This error handler was destined to fail." } }
            it do
              expect(target).to receive(:write).with(stories).exactly(1).times
              expect(target).to receive(:error).with(Exception, stories).exactly(1).times
              expect { subject }.to raise_exception(Exception)
            end
          end
        end
      end
    end
  end
end