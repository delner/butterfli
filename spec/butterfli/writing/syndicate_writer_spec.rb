require 'spec_helper'

describe Butterfli::SyndicateWriter do
  let(:target) { double("target") }
  let(:subscription) { Proc.new { |stories| target.share(stories) } }
  let(:writer) { Butterfli::SyndicateWriter.new }

  before(:each) { Butterfli.subscribe &subscription }
  after(:each) { Butterfli.unsubscribe_all }

  context "#write" do
    subject { writer.write(stories) }
    context "invoked with a story" do
      let(:stories) { [Butterfli::Story.new] }
      it do
        expect(target).to receive(:share).with(stories).exactly(1).times
        subject
      end
    end
    context "invoked with a non-story object" do
      let(:stories) { "I'm just a string." }
      it do
        expect(target).to_not receive(:share)
        subject
      end
    end
  end
end