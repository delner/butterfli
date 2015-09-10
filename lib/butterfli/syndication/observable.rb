module Butterfli::Syndication
  module Observable
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
        return false if !self.providers.empty? && !self.providers.include?(story.source.name)
        return false if !self.types.empty? && !self.types.include?(story.type)
        true
      end
    end

    class MemoryCacheFilter < Set
      def self.max_size
        Butterfli.configuration.memory_cache_filter_max_size
      end
      def push(*stories)
        stories = stories.flatten
        if (self.size + stories.length) > self.class.max_size
          overflow = (self.size + stories.length) - self.class.max_size
          overflow.times { self.delete(self.first) }
        end
        self.merge(stories.collect { |s| s.source.key })
      end
      def already_seen?(story)
        self.include?(story.source.key)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def filter_cache
        @filter_cache ||= Butterfli::Syndication::Observable::MemoryCacheFilter.new
      end
      def subscriptions
        @subscriptions ||= {}
      end

      def subscribe(options = {}, &block)
        if block
          criteria = { types: options[:type], providers: options[:to], block: block }
          new_subscription = Butterfli::Syndication::Observable::Subscription.new(criteria)
          key = block.object_id
          subscriptions[key] = new_subscription
          key
        end
      end
      def syndicate(*stories)
        # Eliminate any obvious duplicates
        stories = stories.flatten.uniq { |story| story.source.key }

        if !stories.empty?
          # Cache some story keys in memory, if enabled, to further reduce duplication
          if Butterfli.configuration.filter_duplicates_with_memory_cache
            stories = stories.reject { |story| filter_cache.already_seen?(story) }
            filter_cache.push(stories)
          end

          # TODO: This could be more efficient... lots of comparisons made here
          #       If we need to, we could do it by index? Keeping it simple for now.
          if !subscriptions.empty?
            subscriptions.values.each do |subscription|
              stories_to_send = stories.select { |story| subscription.matches?(story) }
              subscription.block.call(stories_to_send) if !stories_to_send.empty?
            end
          end
        end
        stories
      end
      def unsubscribe_all
        @subscriptions = {}
      end
    end
  end
end