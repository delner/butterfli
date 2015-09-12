require 'spec_helper'

describe Butterfli::Processing::Worker do
  let(:workable_class) do
    stub_const 'ItemProcessor', Class.new
    ItemProcessor.class_eval { include Butterfli::Processing::Workable }
    ItemProcessor
  end
  let(:target) { double('target') }
  let(:work_block) { Proc.new { true } }
  let(:work_started_block) { Proc.new { true } }
  let(:work_completed_block) { Proc.new { true } }
  let(:work_error_block) { Proc.new { true } }
  let(:worker_death_block) { Proc.new { true } }
  let(:work_item) do
    w = workable_class.new
    w.on_work &work_block
    w.on_work_started &work_started_block
    w.on_work_completed &work_completed_block
    w.on_work_error &work_error_block
    w
  end

  let(:worker_options) { {} }
  let(:worker) { Butterfli::Processing::Worker.new(work_item, worker_options) }
  context "when initialized" do
    context "with no arguments" do
      subject { Butterfli::Processing::Worker.new }
      it do
        expect(subject.after_work).to eq(:block)
        expect(subject.sleep_interval).to eq(1)
      end
    end
    context "with 'after_work'" do
      let(:value) { :continuous }
      subject { Butterfli::Processing::Worker.new(after_work: value) }
      it { expect(subject.after_work).to eq(value) }
    end
    context "with 'sleep_for'" do
      let(:value) { 5 }
      subject { Butterfli::Processing::Worker.new(sleep_for: value) }
      it { expect(subject.sleep_interval).to eq(value) }
    end
    context "with 'on_worker_death'" do
      let(:block) { Proc.new { puts 'Worker died!' } }
      subject { Butterfli::Processing::Worker.new(on_worker_death: block) }
      it { expect(subject.worker_death_block).to eq(block) }
    end
    context "with a work item" do
      subject { Butterfli::Processing::Worker.new(work_item) }
      it do
        expect(subject.work_block).to eq(work_block)
        expect(subject.work_completed_block).to eq(work_completed_block)
        expect(subject.work_error_block).to eq(work_error_block)
      end
      context "and work callbacks" do
        let(:other_work_block) { Proc.new { target.other_work } }
        let(:other_completed_block) { Proc.new { target.other_completed } }
        let(:other_error_block) { Proc.new { target.other_error } }
        subject do
          Butterfli::Processing::Worker.new(work_item,
                                on_work: other_work_block,
                                on_work_completed: other_completed_block,
                                on_work_error: other_error_block)
        end
        it do
          expect(subject.work_block).to eq(work_block)
          expect(subject.work_completed_block).to eq(work_completed_block)
          expect(subject.work_error_block).to eq(work_error_block)
          expect(subject.work_block).to_not eq(other_work_block)
          expect(subject.work_completed_block).to_not eq(other_completed_block)
          expect(subject.work_error_block).to_not eq(other_error_block)
        end
      end
    end
    context "with work callbacks" do
      subject do
        Butterfli::Processing::Worker.new(on_work: work_block,
                                          on_work_started: work_started_block,
                                          on_work_completed: work_completed_block,
                                          on_work_error: work_error_block)
      end
      it do
        expect(subject.work_block).to eq(work_block)
        expect(subject.work_started_block).to eq(work_started_block)
        expect(subject.work_completed_block).to eq(work_completed_block)
        expect(subject.work_error_block).to eq(work_error_block)
      end
    end
  end

  describe "#alive?" do
    subject { worker.alive? }
    context "before the worker is started" do
      it do
        expect(subject).to be false
        expect(worker.thread).to be_nil
      end
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it do
        expect(subject).to be true
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "after the worker has been stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.thread.status).to be false
      end
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.thread.status).to be false
      end
    end
  end
  describe "#died_unexpectedly?" do
    subject { worker.died_unexpectedly? }
    context "before the worker is started" do
      it { expect(subject).to be false }
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it { expect(subject).to be false }
    end
    context "after the worker has been stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it { expect(subject).to be false }
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it { expect(subject).to be false }
    end
    context "after the worker dies unexpectedly" do
      let(:error) { StandardError.new("This job was destined to fail.") }
      let(:work_block) { Proc.new { raise error } }
      let(:work_error_block) { Proc.new { |e| raise e } }
      let(:worker_death_block) { Proc.new { |e| target.death(e) } }
      let(:worker_options) { { on_worker_death: worker_death_block } }
      it do
        expect(target).to receive(:death).with(error)
        worker.start; sleep(0.01)
        expect(subject).to be true
        expect(worker.obituary).to eq(error)
      end
    end
  end
  describe "#blocking?" do
    subject { worker.blocking? }
    context "before the worker is started" do
      it do
        expect(subject).to be false
        expect(worker.thread).to be_nil
      end
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it do
        expect(subject).to be false
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "with" do
      context "'after_work = :block' set" do
        let(:worker_options) { { after_work: :block } }
        context "after worker completes a cycle" do
          let(:work_block) { Proc.new { true } }
          before(:each) { worker.start; sleep(0.01) }
          it { expect(subject).to be true }
        end
      end
      context "'after_work = :sleep' set" do
        let(:worker_options) { { after_work: :sleep } }
        context "after worker completes a cycle" do
          let(:work_block) { Proc.new { true } }
          before(:each) { worker.start; sleep(0.01) }
          it { expect(subject).to be false }
        end
      end
    end
    context "after the worker has been stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.thread.status).to be false
      end
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.thread.status).to be false
      end
    end
  end
  describe "#stopped?" do
    subject { worker.stopped? }
    context "before the worker is started" do
      it { expect(subject).to be true }
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it { expect(subject).to be false }
    end
    context "after the worker has been stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it { expect(subject).to be true }
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it { expect(subject).to be true }
    end
  end
  describe "#should_run?" do
    subject { worker.should_run? }
    context "before the worker is started" do
      it { expect(subject).to be false }
    end
    context "after the worker is started" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; sleep(0.01) }
      it { expect(subject).to be true }
    end
    context "after the worker is signaled to stop" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; sleep(0.01); worker.stop }
      it { expect(subject).to be false }
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; sleep(0.01); worker.kill }
      it { expect(subject).to be false }
    end
  end
  describe "#start" do
    subject { worker.start }
    context "for the first time" do
      let(:work_block) { Proc.new { sleep(1) } }
      it do
        expect(subject).to be true
        expect(worker.alive?).to be true
        expect(worker.should_run?).to be true
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be true
        expect(worker.should_run?).to be true
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "while the worker is sleeping" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be true
        expect(worker.should_run?).to be true
        expect(worker.thread.status).to eq("sleep")
      end
    end
    context "for the second time" do
      context "after the worker has been stopped" do
        let(:work_block) { Proc.new { sleep(0.01) } }
        before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
        it do
          expect(subject).to be true
          expect(worker.alive?).to be true
          expect(worker.should_run?).to be true
          # expect(worker.thread.status).to eq("run")
        end
      end
      context "after the worker has been killed" do
        let(:work_block) { Proc.new { sleep(0.01) } }
        before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
        it do
          expect(subject).to be true
          expect(worker.alive?).to be true
          expect(worker.should_run?).to be true
          # expect(worker.thread.status).to eq("run")
        end
      end
    end
  end
  describe "#wakeup" do
    subject { worker.wakeup }
    context "before the worker has started" do
      it { expect(subject).to be false }
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be true
        expect(worker.should_run?).to be true
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "while the worker is sleeping" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01) }
      it do
        expect(subject).to be true
        expect(worker.alive?).to be true
        expect(worker.should_run?).to be true
        # expect(worker.thread.status).to eq("run")
      end
    end
    context "after the worker has been stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it { expect(subject).to be false }
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it { expect(subject).to be false }
    end
  end
  describe "#stop" do
    subject { worker.stop }
    context "before the worker has started" do
      it { expect(subject).to be false }
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; sleep(0.01) }
      it do
        expect(subject).to be true
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker signaled to stop" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; worker.stop }
      it do
        expect(subject).to be false
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker has stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be false
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { sleep(0.01) } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be false
        expect(worker.should_run?).to be false
      end
    end
  end
  describe "#kill" do
    subject { worker.kill }
    context "before the worker has started" do
      it { expect(subject).to be false }
    end
    context "while the worker is running" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; sleep(0.01) }
      it do
        expect(subject).to be true
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker signaled to stop" do
      let(:work_block) { Proc.new { sleep(1) } }
      before(:each) { worker.start; worker.stop }
      it do
        expect(subject).to be true
        # expect(worker.alive?).to be true # Not a reliable expectation
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker has stopped" do
      let(:work_block) { Proc.new { true } }
      before(:each) { worker.start; sleep(0.01); worker.stop; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be false
        expect(worker.should_run?).to be false
      end
    end
    context "after the worker has been killed" do
      let(:work_block) { Proc.new { sleep(0.01) } }
      before(:each) { worker.start; sleep(0.01); worker.kill; sleep(0.01) }
      it do
        expect(subject).to be false
        expect(worker.alive?).to be false
        expect(worker.should_run?).to be false
      end
    end
  end

  context "when work is ongoing" do
    let(:work_block) { Proc.new { target.working } }
    subject { worker.start }
    it do
      expect(target).to receive(:working).exactly(1).times
      subject
      sleep(0.01) # Give worker a chance to start
    end
  end
  context "when work is started" do
    let(:work_started_block) { Proc.new { target.started } }
    subject { worker.start }
    it do
      expect(target).to receive(:started).exactly(1).times
      subject
      sleep(0.01) # Give worker a chance to start
    end
  end
  context "when work is completed" do
    let(:work_result) { true }
    let(:work_block) { Proc.new { work_result } }
    let(:work_completed_block) { Proc.new { |result| target.completed(result) } }
    subject { worker.start }
    it do
      expect(target).to receive(:completed).with(work_result).exactly(1).times
      subject
      sleep(0.01) # Give worker a chance to complete
    end
  end
  context "when work has an error" do
    let(:error) { StandardError.new("This job was destined to fail.") }
    let(:work_block) { Proc.new { raise error } }
    let(:work_error_block) { Proc.new { |e| target.error(e) } }
    subject { worker.start }
    it do
      expect(target).to receive(:error).with(error).exactly(1).times
      subject
      sleep(0.01) # Give worker a chance to error
    end
    context "and raises another exception" do
      let(:work_error_block) { Proc.new { |e| raise e } }
      it do
        subject
        sleep(0.01) # Give worker a chance to die horribly
        expect(worker.died_unexpectedly?).to be true
        expect(worker.obituary).to eq(error)
      end
    end
  end
end