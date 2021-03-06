require 'spec_helper'

describe Butterfli::Writing::SyndicateWriter do
  let(:target) { double("target") }
  let(:subscription) { Proc.new { |stories| target.share(stories) } }
  let(:writer) { Butterfli::Writing::SyndicateWriter.new }

  before(:each) { Butterfli.subscribe &subscription }
  after(:each) { Butterfli.unsubscribe_all }

  context "#write" do
    subject { writer.write(channel, stories) }
    context "invoked on the 'stories' channel" do
      let(:channel) { :stories }
      context "invoked with a story" do
        let(:stories) { [Butterfli::Data::Story.new] }
        it do
          expect(target).to receive(:share).with(stories).exactly(1).times
          subject
        end
      end
      context "invoked with a non-story object" do
        let(:stories) { "I'm just a string." }
        it do
          # We don't expect the syndicate writer to filter non-stories
          expect(target).to receive(:share).with([stories]).exactly(1).times
          subject
        end
      end
    end
  end
end