require 'spec_helper'

describe Butterfli::StoryJob do
  let(:writer) { double('writer') }
  let(:processor) { Butterfli::Processor::Base.new(writers: [writer]) }
  before(:each) { Butterfli.processor = processor }
  after(:each) { Butterfli.processor = nil }

  context "base class is instantiated" do
    let(:job) { Butterfli::StoryJob.new }
    context "and #work is invoked" do
      subject { job.work }
      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end
  context "inheriting class" do
    let(:work_definition) { Proc.new { } }
    let(:story_class) do
      stub_const 'TestStoryJob', Class.new(Butterfli::StoryJob)
      TestStoryJob
    end
    let(:job) { story_class.new }

    context "which doesn't implement #get_stories" do
      context "is instantiated" do
        context "and #work is invoked" do
          subject { job.work }
          it { expect { subject }.to raise_error(NoMethodError) }
        end
      end
    end
    context "which implements #get_stories" do
      before(:each) { story_class.send :define_method, :get_stories, &get_stories_block }
      context "is instantiated" do
        context "and #work is invoked" do
          subject { job.work }
          context "which returns nil" do
            let(:get_stories_block) { Proc.new { return nil } }
            it { expect(subject).to be_empty }
          end
          context "which returns a Story" do
            let(:get_stories_block) { Proc.new { return Butterfli::Story.new } }
            it do
              expect(writer).to receive(:write_with_error_handling).with(instance_of(Array)).exactly(1).times
              expect(subject).to have(1).items
            end
          end
          context "which returns a non-Story object" do
            let(:get_stories_block) { Proc.new { return 1 } }
            it { expect(subject).to be_empty }
          end
          context "which returns an Array containing Story objects" do
            let(:get_stories_block) { Proc.new { return [Butterfli::Story.new, Butterfli::Story.new] } }
            it do
              expect(writer).to receive(:write_with_error_handling).with(instance_of(Array)).exactly(1).times
              expect(subject).to have(2).items
            end
          end
          context "which returns an Array containing non-Story objects" do
            let(:get_stories_block) { Proc.new { return [1, 2] } }
            it { expect(subject).to be_empty }
          end
          context "which raises a StandardError" do
            let(:get_stories_block) { Proc.new { raise "This job was destined to fail." } }
            it { expect { subject }.to raise_error(StandardError) }
          end
        end
      end
    end
  end
end