require 'spec_helper'

describe Butterfli::Jobs::StoryJob do
  let(:writer) { double('writer') }
  before(:each) { Butterfli.writers << writer }
  after(:each) { Butterfli.writers = nil }

  context "base class is instantiated" do
    let(:job) { Butterfli::Jobs::StoryJob.new }
    context "and #work is invoked" do
      subject { job.work }
      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end
  # TODO: These aren't really unit tests... should break them up
  context "inheriting class" do
    let(:story_class) do
      stub_const 'TestStoryJob', Class.new(Butterfli::Jobs::StoryJob)
      # NOTE: We add this #set_write_block because class definitions cannot access Rspec variables (out of scope)
      TestStoryJob.send :define_method, :set_get_stories_block do |&block| instance_variable_set(:@get_stories_block, block) end
      TestStoryJob.send :define_method, :get_stories do instance_variable_get(:@get_stories_block).call end
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
      before(:each) { job.set_get_stories_block(&get_stories_block) }
      context "is instantiated" do
        context "and #work is invoked" do
          subject { job.work }
          context "which returns nil" do
            let(:get_stories_block) { Proc.new { nil } }
            it { expect(subject).to be_empty }
          end
          context "which returns a Story" do
            let(:get_stories_block) { Proc.new { Butterfli::Data::Story.new } }
            it do
              expect(writer).to receive(:write_with_error_handling).with(:stories, instance_of(Array)).exactly(1).times
              expect(subject).to have(1).items
            end
          end
          context "which returns a non-Story object" do
            let(:get_stories_block) { Proc.new { 1 } }
            it { expect(subject).to be_empty }
          end
          context "which returns an Array containing Story objects" do
            let(:get_stories_block) { Proc.new { [Butterfli::Data::Story.new, Butterfli::Data::Story.new] } }
            it do
              expect(writer).to receive(:write_with_error_handling).with(:stories, instance_of(Array)).exactly(1).times
              expect(subject).to have(2).items
            end
          end
          context "which returns an Array containing non-Story objects" do
            let(:get_stories_block) { Proc.new { [1, 2] } }
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