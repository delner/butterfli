module Butterfli::Observable
  class Subscription < Hash

    def initialize(options = {})
      # TODO: This could be cleaner
      [:types, :providers].each do |array_type|
        val = options[array_type] || []
        val = [val] if !val.is_a?(Array)
        options.merge!(array_type => val.collect(&:to_sym))
      end
      self.merge!(options)
    end
    def types
      self[:types] ||= []
    end
    def providers
      self[:providers] ||= []
    end
    def block
      self[:block]
    end
    def matches?(story)
      return false if !self.providers.empty? && !self.providers.include?(story.source)
      return false if !self.types.empty? && !self.types.include?(story.type)
      true
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
      if block
        criteria = { types: options[:type], providers: options[:to], block: block }
        new_subscription = Butterfli::Observable::Subscription.new(criteria)
        key = block.object_id
        subscriptions[key] = new_subscription
        key
      end
    end
    def syndicate(*stories)
      stories = stories.flatten
      # TODO: This could be more efficient... lots of comparisons made here
      #       If we need to, we could do it by index? Keeping it simple for now.
      if !stories.empty? && !subscriptions.empty?
        subscriptions.values.each do |subscription|
          stories_to_send = stories.select { |story| subscription.matches?(story) }
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

# Inject module into the global namespace
Butterfli.class_eval { include Butterfli::Observable }