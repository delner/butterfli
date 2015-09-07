require 'spec_helper'

describe Butterfli::Job do
  before(:each) { Butterfli::Job.reset_all_callbacks! }
  after(:each) { Butterfli::Job.reset_all_callbacks! }

  context "#before_work" do
    let(:callback) { Proc.new { } }
    subject { Butterfli::Job.before_work &callback }
    it do
      subject
      expect(Butterfli::Job.before_work_callbacks).to include(callback)
      expect(Butterfli::Job.new.before_work_callbacks).to include(callback)
    end
  end
  context "#after_work" do
    let(:callback) { Proc.new { } }
    subject { Butterfli::Job.after_work &callback }
    it do
      subject
      expect(Butterfli::Job.after_work_callbacks).to include(callback)
      expect(Butterfli::Job.new.after_work_callbacks).to include(callback)
    end
  end

  context "base class is instantiated" do
    let(:job) { Butterfli::Job.new }
    context "and #work is invoked" do
      subject { job.work }
      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end
  # TODO: These aren't really unit tests... should break them up
  context "inheriting class" do
    let(:job_class) do
      stub_const 'TestJob', Class.new(Butterfli::StoryJob)
      # NOTE: We add this #set_write_block because class definitions cannot access Rspec variables (out of scope)
      TestJob.send :define_method, :set_do_work_block do |&block| instance_variable_set(:@do_work_block, block) end
      TestJob.send :define_method, :do_work do instance_variable_get(:@do_work_block).call end
      TestJob
    end
    let(:job) { job_class.new }

    context "which doesn't implement #do_work" do
      context "is instantiated" do
        context "and #work is invoked" do
          subject { job.work }
          it { expect { subject }.to raise_error(NoMethodError) }
        end
      end
    end
    context "which implements #do_work" do
      before(:each) { job.set_do_work_block(&do_work_block) }
      context "is instantiated" do
        context "and #work is invoked" do
          subject { job.work }
          context "which returns a value" do
            let(:value) { "Success!" }
            let(:do_work_block) { Proc.new { value } }
            it { expect(subject).to eq(value) }
          end
          context "which raises a StandardError" do
            let(:do_work_block) { Proc.new { raise "This job was destined to fail." } }
            it { expect { subject }.to raise_error(StandardError) }
          end
        end
      end
    end
  end

  context "#work" do
    let(:job_class) do
      stub_const 'TestJob', Class.new(Butterfli::StoryJob)
      # NOTE: We add this #set_write_block because class definitions cannot access Rspec variables (out of scope)
      TestJob.send :define_method, :set_do_work_block do |&block| instance_variable_set(:@do_work_block, block) end
      TestJob.send :define_method, :do_work do instance_variable_get(:@do_work_block).call end
      TestJob
    end
    let(:job) { job_class.new }
    let(:work_output) { true }

    subject { job.work }
    context "when callbacks are attached" do
      let(:target) { double('target') }
      let(:before_callback) { Proc.new { target.before } }
      let(:after_callback) { Proc.new { |output| target.after(output) } }
      before(:each) do
        Butterfli::Job.before_work &before_callback
        Butterfli::Job.after_work &after_callback
        job.set_do_work_block do work_output end
      end
      it do
        expect(target).to receive(:before).exactly(1).times
        expect(target).to receive(:after).with(work_output).exactly(1).times
        expect(subject).to eq(work_output)
      end
    end
  end

  context "when instantiated" do
    let(:args) { {} }
    subject { Butterfli::Job.new(args) }
    context "with no arguments" do
      it { expect(subject.args).to be_empty }
    end
    context "with arguments" do
      let(:args) { { param: 1 } }
      it { expect(subject.args).to eq(args) }
    end
  end
  context "given two instances" do
    let(:job_class_one) do
      stub_const 'JobOne', Class.new(Butterfli::Job)
      JobOne
    end
    let(:job_class_two) do
      stub_const 'JobTwo', Class.new(Butterfli::Job)
      JobTwo
    end
    context "of the same class" do
      context "and the same arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_one.new(value: 1) }
        it do
          expect(job_one.hash).to eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be true
        end
      end
      context "and different arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_one.new(value: 2) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
    end
    context "of different classes" do
      context "and the same arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_two.new(value: 1) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
      context "and different arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_two.new(value: 2) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
    end
  end
end