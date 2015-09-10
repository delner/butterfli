require 'spec_helper'

describe Butterfli::Processing::MonolithProcessor do
  let(:processor_options) { { num_workers: 1, after_work: :block } }
  let(:processor) { Butterfli::Processing::MonolithProcessor.new(processor_options) }

  it { expect(Butterfli::Processing::MonolithProcessor < Butterfli::Processing::Workable).to be true }
  it { expect(Butterfli::Processing::MonolithProcessor < Butterfli::Processing::WorkPool).to be true }

  context "when initialized" do
    subject { processor }
    context "with number of workers" do
      let(:num_workers) { 2 }
      let(:processor_options) { { num_workers: num_workers } }
      it { expect(processor.workers).to have(num_workers).items }
    end
  end
  describe "#queue" do
    subject { processor.queue }
    context "before any jobs have been added" do
      it { expect(subject).to be_empty }
    end
    context "after a job has been added" do
      before(:each) { processor.enqueue(Butterfli::Jobs::Job.new) }
      it { expect(subject).to have(1).items }
    end
  end
  describe "#mutex" do
    subject { processor.mutex }
    it { expect(subject).to_not be_nil }
  end
  describe "#enqueue" do
    let(:job) { Butterfli::Jobs::Job.new }
    subject { processor.enqueue(job) }
    context "when there are no jobs in the queue" do
      it do
        expect(subject).to be true
        expect(processor.queue).to have(1).items
      end
    end
    context "when there is a job" do
      context "that is identical" do
        let(:identical_job) { Butterfli::Jobs::Job.new }
        before(:each) { processor.enqueue(identical_job) }
        it do
          expect(subject).to be false
          expect(processor.queue).to have(1).items
          expect(processor.queue.first).to_not eq(job)
        end
      end
      context "that is different" do
        let(:different_job) { Butterfli::Jobs::Job.new(arg: 1) }
        before(:each) { processor.enqueue(different_job) }
        it do
          expect(subject).to be true
          expect(processor.queue).to have(2).items
          expect(processor.queue.first).to eq(different_job)
          expect(processor.queue.include?(job)).to be true
        end
      end
    end
  end
  describe "#dequeue" do
    subject { processor.dequeue }
    context "when there are no jobs in the queue" do
      it { expect(subject).to be_nil }
    end
    context "when there is a job in the queue" do
      let(:job) { Butterfli::Jobs::Job.new }
      before(:each) { processor.enqueue(job) }
      it { expect(subject).to eq(job) }
    end
  end
  describe "#pending_jobs?" do
    subject { processor.pending_jobs? }
    context "when there are no jobs in the queue" do
      it { expect(subject).to be false }
    end
    context "when there is a job in the queue" do
      let(:job) { Butterfli::Jobs::Job.new }
      before(:each) { processor.enqueue(job) }
      it { expect(subject).to be true }
    end
  end

  context "while the processor is running" do
    before(:each) { processor.start }
    context "when a job is queued" do
      let(:return_value) { "Job finished." }
      let(:job) { double('job') }
      before(:each) { allow(job).to receive(:work) { return_value } }
      it do
        expect(job).to receive(:work).exactly(1).times
        processor.enqueue(job)
        sleep(0.03) # Give worker a chance to do work
      end
    end
  end
end