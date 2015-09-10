require 'spec_helper'

describe Butterfli::Processing::MonolithProcessorAdapter do
  let(:adapter_options) { { num_workers: 1, after_work: :block } }
  let(:adapter) { Butterfli::Processing::MonolithProcessorAdapter.new(adapter_options) }

  it { expect(Butterfli::Processing::MonolithProcessorAdapter < Butterfli::Processing::Workable).to be true }
  it { expect(Butterfli::Processing::MonolithProcessorAdapter < Butterfli::Processing::WorkPool).to be true }

  context "when initialized" do
    subject { adapter }
    context "with number of workers" do
      let(:num_workers) { 2 }
      let(:adapter_options) { { num_workers: num_workers } }
      it { expect(adapter.workers).to have(num_workers).items }
    end
  end
  describe "#queue" do
    subject { adapter.queue }
    context "before any jobs have been added" do
      it { expect(subject).to be_empty }
    end
    context "after a job has been added" do
      let(:queue) { :jobs }
      before(:each) { adapter.enqueue(queue, Butterfli::Jobs::Job.new) }
      it { expect(subject).to have(1).items }
    end
  end
  describe "#mutex" do
    subject { adapter.mutex }
    it { expect(subject).to_not be_nil }
  end
  describe "#enqueue" do
    let(:job) { Butterfli::Jobs::Job.new }
    let(:queue) { :jobs }
    subject { adapter.enqueue(queue, job) }
    context "when there are no jobs in the queue" do
      it do
        expect(subject).to be true
        expect(adapter.queue).to have(1).items
      end
    end
    context "when there is a job" do
      context "that is identical" do
        let(:identical_job) { Butterfli::Jobs::Job.new }
        before(:each) { adapter.enqueue(queue, identical_job) }
        it do
          expect(subject).to be false
          expect(adapter.queue).to have(1).items
          expect(adapter.queue.first).to_not eq(job)
        end
      end
      context "that is different" do
        let(:different_job) { Butterfli::Jobs::Job.new(arg: 1) }
        before(:each) { adapter.enqueue(queue, different_job) }
        it do
          expect(subject).to be true
          expect(adapter.queue).to have(2).items
          expect(adapter.queue.first).to eq(different_job)
          expect(adapter.queue.include?(job)).to be true
        end
      end
    end
  end
  describe "#dequeue" do
    subject { adapter.dequeue(queue) }
    let(:queue) { :jobs }
    context "when there are no jobs in the queue" do
      it { expect(subject).to be_nil }
    end
    context "when there is a job in the queue" do
      let(:job) { Butterfli::Jobs::Job.new }
      before(:each) { adapter.enqueue(queue, job) }
      it { expect(subject).to eq(job) }
    end
  end
  describe "#pending_jobs?" do
    subject { adapter.pending_jobs? }
    let(:queue) { :jobs }

    context "when there are no jobs in the queue" do
      it { expect(subject).to be false }
    end
    context "when there is a job in the queue" do
      let(:job) { Butterfli::Jobs::Job.new }
      before(:each) { adapter.enqueue(queue, job) }
      it { expect(subject).to be true }
    end
  end

  context "while the processor is running" do
    before(:each) { adapter.start }
    context "when a job is queued" do
      let(:return_value) { "Job finished." }
      let(:job) { double('job') }
      let(:queue) { :jobs }
      before(:each) { allow(job).to receive(:work) { return_value } }
      it do
        expect(job).to receive(:work).exactly(1).times
        adapter.enqueue(queue, job)
        sleep(0.03) # Give worker a chance to do work
      end
    end
  end
end