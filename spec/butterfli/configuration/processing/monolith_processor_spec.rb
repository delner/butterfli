require 'spec_helper'

describe Butterfli::Configuration::Processing::MonolithProcessor do
  context "when configured in Butterfli" do
    let(:after_work) { :sleep }
    let(:num_workers) { 2 }
    let(:sleep_for) { 10 }
    let(:on_job_started) { Proc.new { true } }
    let(:on_job_completed) { Proc.new { true } }
    let(:on_job_error) { Proc.new { true } }
    let(:on_work_started) { Proc.new { true } }
    let(:on_work_completed) { Proc.new { true } }
    let(:on_work_error) { Proc.new { true } }
    let(:on_worker_death) { Proc.new { true } }
    before(:each) do
      Butterfli.processor = nil
      Butterfli.configure do |config|
        config.processor :monolith do |processor|
          processor.after_work = after_work
          processor.num_workers = num_workers
          processor.sleep_for = sleep_for
          processor.on_job_started &on_job_started
          processor.on_job_completed &on_job_completed
          processor.on_job_error &on_job_error
          processor.on_work_started &on_work_started
          processor.on_work_completed &on_work_completed
          processor.on_work_error &on_work_error
          processor.on_worker_death &on_worker_death
        end
      end
    end
    after(:each) { Butterfli.processor = nil }
    subject { Butterfli.processor.adapter }
    it { expect(Butterfli.processor).to be_a_kind_of(Butterfli::Processing::Processor) }
    it { expect(subject).to be_a_kind_of(Butterfli::Processing::MonolithProcessorAdapter) }
    it { expect(subject.workers.first.after_work).to eq(after_work) }
    it { expect(subject.workers.first.sleep_interval).to eq(sleep_for) }
    it { expect(subject.workers.length).to eq(num_workers) }
    it { expect(subject.job_started_block).to eq(on_job_started) }
    it { expect(subject.job_completed_block).to eq(on_job_completed) }
    it { expect(subject.job_error_block).to eq(on_job_error) }
    it { expect(subject.work_started_block).to eq(on_work_started) }
    it { expect(subject.work_completed_block).to eq(on_work_completed) }
    it { expect(subject.work_error_block).to eq(on_work_error) }
    it { expect(subject.workers.first.worker_death_block).to eq(on_worker_death) }
  end
end