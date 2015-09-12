require 'spec_helper'

describe Butterfli::Processing::Subworkable do
  let(:subworkable_class) do
    stub_const 'ItemProcessor', Class.new
    ItemProcessor.class_eval { include Butterfli::Processing::Subworkable }
    ItemProcessor
  end
  subject { subworkable_class }

  context "instance" do
    subject { super().new }
    describe "#on_job_started" do
      context "when given a block" do
        let(:job_started_block) { Proc.new { puts "Job started!" } }
        before(:each) { subject.on_job_started &job_started_block }
        it { expect(subject.job_started_block).to eq(job_started_block) }
      end
    end
    describe "#on_job_completed" do
      context "when given a block" do
        let(:job_completed_block) { Proc.new { puts "Job completed!" } }
        before(:each) { subject.on_job_completed &job_completed_block }
        it { expect(subject.job_completed_block).to eq(job_completed_block) }
      end
    end
    describe "#on_job_error" do
      context "when given a block" do
        let(:job_error_block) { Proc.new { puts "Job error!" } }
        before(:each) { subject.on_job_error &job_error_block }
        it { expect(subject.job_error_block).to eq(job_error_block) }
      end
    end
  end
end