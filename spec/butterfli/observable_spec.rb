require 'spec_helper'

RSpec.shared_examples "an observable #subscribe call" do
  it { expect(subject).to be_a_kind_of(Fixnum) }
  it { expect(subject).to eq(subscription.object_id) }
end

describe Butterfli::Observable do
  let(:observable_class) do
    stub_const 'Instabook', Module.new
    Instabook.class_eval { include Butterfli::Observable }
    Instabook
  end
  subject { observable_class }
  # Make sure subscriber list is always clean
  # before(:each) { subject.unsubscribe_all }

  describe "#subscriptions" do
    subject { super().subscriptions }
    context "when nothing has subscribed" do
      it { expect(subject).to be_empty }
    end
    context "when something has subscribed" do
      before(:each) { observable_class.subscribe { puts "Story received." } }
      it { expect(subject).to have(1).items }
    end
  end
  describe "subscription (subscribe/syndicate)" do
    let(:target) { double("target") }
    let(:subscription) { Proc.new { |stories| target.share(stories) } }

    # Invoke #subscribe before each example
    before(:each) do
      subject 
    end
    
    context "when setup with only a block" do
      subject do
        super().subscribe &subscription
      end

      it_behaves_like "an observable #subscribe call"
      
      context "and a single story is syndicated" do
        let(:story) { Butterfli::Story.new.merge!(type: :image) }
        it do
          expect(target).to receive(:share).with([story])
          observable_class.syndicate(story)
        end
      end
      context "and multiple stories" do
        let(:stories) { [story_one, story_two] }
        context "all of same type are syndicated" do
          let(:story_one) { Butterfli::Story.new.merge!(type: :image) }
          let(:story_two) { Butterfli::Story.new.merge!(type: :image) }
          it do
            expect(target).to receive(:share).with(stories)
            observable_class.syndicate(stories)
          end
        end
        context "none of same type are syndicated" do
          let(:story_one) { Butterfli::Story.new.merge!(type: :image) }
          let(:story_two) { Butterfli::Story.new.merge!(type: :video) }
          it do
            expect(target).to receive(:share).with(stories)
            observable_class.syndicate(stories)
          end
        end
      end
    end
    context "when setup with a block and" do
      context "a type to listen for" do
        let(:subscription_type) { :image }
        let(:other_subscription_type) { :video }
        subject do
          super().subscribe to: subscription_type, &subscription
        end

        it_behaves_like "an observable #subscribe call"

        context "and a single story" do
          context "of matching type is syndicated" do
            let(:story) { Butterfli::Story.new.merge!(type: subscription_type) }
            it do
              expect(target).to receive(:share).with([story])
              observable_class.syndicate(story)
            end
          end
          context "of non-matching type is syndicated" do
            let(:story) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(story)
            end
          end
        end
        context "and multiple stories" do
          context "all of matching type are syndicated" do
            let(:matching_story_one) { Butterfli::Story.new.merge!(type: subscription_type) }
            let(:matching_story_two) { Butterfli::Story.new.merge!(type: subscription_type) }
            let(:stories) { [matching_story_one, matching_story_two] }
            it do
              expect(target).to receive(:share).with(stories)
              observable_class.syndicate(stories)
            end
          end
          context "some of matching type are syndicated" do
            let(:matching_story) { Butterfli::Story.new.merge!(type: subscription_type) }
            let(:non_matching_story) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:stories) { [matching_story, non_matching_story] }
            it do
              expect(target).to receive(:share).with([matching_story])
              observable_class.syndicate(stories)
            end
          end
          context "none of matching type are syndicated" do
            let(:non_matching_story_one) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:non_matching_story_two) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:stories) { [non_matching_story_one, non_matching_story_two] }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(stories)
            end
          end
        end
      end
      context "multiple types to listen for" do
        let(:subscription_types) { [:image, :video] }
        let(:other_subscription_type) { :audio }
        subject do
          super().subscribe to: subscription_types, &subscription
        end

        it_behaves_like "an observable #subscribe call"

        context "and a single story" do
          context "of matching type is syndicated" do
            let(:story) { Butterfli::Story.new.merge!(type: subscription_types.first) }
            it do
              expect(target).to receive(:share).with([story])
              observable_class.syndicate(story)
            end
          end
          context "of non-matching type is syndicated" do
            let(:story) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(story)
            end
          end
        end
        context "and multiple stories" do
          context "all of matching type are syndicated" do
            let(:matching_story_one) { Butterfli::Story.new.merge!(type: subscription_types.first) }
            let(:matching_story_two) { Butterfli::Story.new.merge!(type: subscription_types.last) }
            let(:stories) { [matching_story_one, matching_story_two] }
            it do
              expect(target).to receive(:share).with(stories)
              observable_class.syndicate(stories)
            end
          end
          context "some of matching type are syndicated" do
            let(:matching_story) { Butterfli::Story.new.merge!(type: subscription_types.first) }
            let(:non_matching_story) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:stories) { [matching_story, non_matching_story] }
            it do
              expect(target).to receive(:share).with([matching_story])
              observable_class.syndicate(stories)
            end
          end
          context "none of matching type are syndicated" do
            let(:non_matching_story_one) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:non_matching_story_two) { Butterfli::Story.new.merge!(type: other_subscription_type) }
            let(:stories) { [non_matching_story_one, non_matching_story_two] }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(stories)
            end
          end
        end
      end
    end
  end
  describe "#unsubscribe" do
    # TODO: Fill this in if ever implemented.
  end
  describe "#unsubscribe_all" do
    context "when there are active subscriptions" do
      let(:target) { double("target") }
      let(:subscription) { Proc.new { |stories| target.share(stories) } }
      subject { super().unsubscribe_all }

      before(:each) do
        observable_class.subscribe &subscription
      end

      it do
        expect(observable_class.subscriptions).to have(1).items
        subject
        expect(observable_class.subscriptions).to be_empty
      end
    end
  end
end