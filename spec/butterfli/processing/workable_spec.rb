require 'spec_helper'

describe Butterfli::Processing::Workable do
  let(:workable_class) do
    stub_const 'ItemProcessor', Class.new
    ItemProcessor.class_eval { include Butterfli::Processing::Workable }
    ItemProcessor
  end
  subject { workable_class }

  context "instance" do
    subject { super().new }
    describe "#on_work_started" do
      context "when given a block" do
        let(:work_started_block) { Proc.new { puts "Work started!" } }
        before(:each) { subject.on_work_started &work_started_block }
        it { expect(subject.work_started_block).to eq(work_started_block) }
      end
    end
    describe "#on_work_completed" do
      context "when given a block" do
        let(:work_completed_block) { Proc.new { puts "Work completed!" } }
        before(:each) { subject.on_work_completed &work_completed_block }
        it { expect(subject.work_completed_block).to eq(work_completed_block) }
      end
    end
    describe "#on_work_error" do
      context "when given a block" do
        let(:work_error_block) { Proc.new { puts "Work error!" } }
        before(:each) { subject.on_work_error &work_error_block }
        it { expect(subject.work_error_block).to eq(work_error_block) }
      end
    end
  end
end