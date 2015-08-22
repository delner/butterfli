module Butterfli::Observable
  class Subscription < Hash
    def initialize(options = {})
      t = options[:types] || []
      t = [t] if !t.is_a?(Array)
      self.merge!(options.merge(types: t))
    end
    def types
      self[:types] ||= []
    end
    def block
      self[:block]
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def subscriptions
      @subscriptions ||= {}
    end
    def subscribe(options = {}, &block)
      new_subscription = Butterfli::Observable::Subscription.new(types: options[:to], block: block)
      key = block.object_id
      subscriptions[key] = new_subscription
      key
    end
    def syndicate(*stories)
      stories = stories.flatten
      if !stories.empty?
        story_groups = stories.group_by { |s| s.type }
        subscriptions.values.each do |subscription|
          if subscription.types.empty?
            # Then send everything
            stories_to_send = story_groups.values.flatten
          else
            # Only send matching types
            stories_to_send = subscription.types.inject([]) do |result, type|
              result.concat(story_groups[type]) if story_groups.has_key?(type)
              result
            end
          end
          subscription.block.call(stories_to_send) if !stories_to_send.empty?
        end
      end
      stories
    end
    def unsubscribe_all
      @subscriptions = {}
    end
  end
end