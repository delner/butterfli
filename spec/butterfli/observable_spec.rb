require 'spec_helper'

RSpec.shared_examples "an observable #subscribe call" do
  it { expect(subject).to be_a_kind_of(Fixnum) }
  it { expect(subject).to eq(subscription.object_id) }
end

# For testing #subscribe with "to" and "type" options
RSpec.shared_examples "an observable #subscribe call with a parameter" do |field_name, positive_values, negative_value|
  context "and a single story" do
    context "of matching type is syndicated" do
      let(:matching_story) { Butterfli::Story.new.merge!(field_name => positive_values.first) }
      it do
        expect(target).to receive(:share).with([matching_story])
        observable_class.syndicate(matching_story)
      end
    end
    context "of non-matching type is syndicated" do
      let(:non_matching_story) { Butterfli::Story.new.merge!(field_name => negative_value) }
      it do
        expect(target).to_not receive(:share)
        observable_class.syndicate(non_matching_story)
      end
    end
  end
  context "and multiple stories" do
    context "all of matching type are syndicated" do
      let(:matching_story_one) { Butterfli::Story.new.merge!(field_name => positive_values.first) }
      let(:matching_story_two) { Butterfli::Story.new.merge!(field_name => positive_values.last) }
      let(:stories) { [matching_story_one, matching_story_two] }
      it do
        expect(target).to receive(:share).with(stories)
        observable_class.syndicate(stories)
      end
    end
    context "some of matching type are syndicated" do
      let(:matching_story) { Butterfli::Story.new.merge!(field_name => positive_values.first) }
      let(:non_matching_story) { Butterfli::Story.new.merge!(field_name => negative_value) }
      let(:stories) { [matching_story, non_matching_story] }
      it do
        expect(target).to receive(:share).with([matching_story])
        observable_class.syndicate(stories)
      end
    end
    context "none of matching type are syndicated" do
      let(:non_matching_story_one) { Butterfli::Story.new.merge!(field_name => negative_value) }
      let(:non_matching_story_two) { Butterfli::Story.new.merge!(field_name => negative_value) }
      let(:stories) { [non_matching_story_one, non_matching_story_two] }
      it do
        expect(target).to_not receive(:share)
        observable_class.syndicate(stories)
      end
    end
  end
end

describe Butterfli::Observable do
  let(:observable_class) do
    stub_const 'Instabook', Module.new
    Instabook.class_eval { include Butterfli::Observable }
    Instabook
  end
  subject { observable_class }

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
        subject do
          super().subscribe type: :image, &subscription
        end
        it_behaves_like "an observable #subscribe call"
        it_behaves_like "an observable #subscribe call with a parameter", :type, [:image], :video
      end
      context "multiple types to listen for" do
        subject do
          super().subscribe type: [:image, :video], &subscription
        end
        it_behaves_like "an observable #subscribe call"
        it_behaves_like "an observable #subscribe call with a parameter", :type, [:image, :video], :audio
      end
      context "a provider to listen to" do
        subject do
          super().subscribe to: :good_provider, &subscription
        end
        it_behaves_like "an observable #subscribe call"
        it_behaves_like "an observable #subscribe call with a parameter", :source, [:good_provider], :bad_provider
      end
      context "multiple providers to listen to" do
        subject do
          super().subscribe to: [:good_provider_one, :good_provider_two], &subscription
        end
        it_behaves_like "an observable #subscribe call"
        it_behaves_like "an observable #subscribe call with a parameter", :source, [:good_provider_one, :good_provider_two], :bad_provider
      end
      context "both a provider and type to listen to" do
        let(:subscription_type) { :image }
        let(:other_subscription_type) { :video }
        let(:provider_name) { :good_provider }
        let(:non_matching_provider_name) { :bad_provider }
        subject do
          super().subscribe to: provider_name, type: subscription_type, &subscription
        end

        it_behaves_like "an observable #subscribe call"

        context "and a single story" do
          context "of both matching provider and type is syndicated" do
            let(:matching_story) { Butterfli::Story.new.merge!(source: provider_name, type: subscription_type) }
            it do
              expect(target).to receive(:share).with([matching_story])
              observable_class.syndicate(matching_story)
            end
          end
          context "of matching provider but not type is syndicated" do
            let(:non_matching_story) { Butterfli::Story.new.merge!(source: provider_name, type: other_subscription_type) }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(non_matching_story)
            end
          end
          context "of matching type but not provider is syndicated" do
            let(:non_matching_story) { Butterfli::Story.new.merge!(source: non_matching_provider_name, type: subscription_type) }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(non_matching_story)
            end
          end
          context "of neither matching provider nor type is syndicated" do
            let(:non_matching_story) { Butterfli::Story.new.merge!(source: non_matching_provider_name, type: other_subscription_type) }
            it do
              expect(target).to_not receive(:share)
              observable_class.syndicate(non_matching_story)
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

  context "when two classes are observable" do
    let(:observable_class_two) do
      stub_const 'Facegram', Module.new
      Facegram.class_eval { include Butterfli::Observable }
      Facegram
    end
    context "and subscriptions are setup on each" do
      let(:target_one) { double("target_one") }
      let(:subscription_one) { Proc.new { |stories| target_one.share(stories) } }

      let(:target_two) { double("target_two") }
      let(:subscription_two) { Proc.new { |stories| target_two.share(stories) } }

      before(:each) do
        observable_class.subscribe &subscription_one
        observable_class_two.subscribe &subscription_two
      end

      context "and a story is syndicated" do
        let(:story) { Butterfli::Story.new.merge!(type: :image) }
        context "to the first" do
          it do
            expect(target_one).to receive(:share).with([story])
            expect(target_two).to_not receive(:share)
            observable_class.syndicate(story)
          end
        end
        context "to the second" do
          it do
            expect(target_one).to_not receive(:share)
            expect(target_two).to receive(:share).with([story])
            observable_class_two.syndicate(story)
          end
        end
      end
    end
  end
end