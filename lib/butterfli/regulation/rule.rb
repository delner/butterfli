require 'butterfli/regulation/rule/matcher'
require 'butterfli/regulation/rule/condition'
require 'butterfli/regulation/rule/fact'

module Butterfli::Regulation
  module Rule
    def applies_to?(item)
      if !self.class.matchers.empty?
        applies = self.class.matchers.inject(true) do |applies, matcher|
          applies && (matcher.call(self, item) == true)
        end
      else
        false
      end
    end
    def permits?(item)
      permitted = self.class.conditions.inject(true) do |permitted, condition|
        permitted && (condition.call(self, item) == true)
      end
    end
    def fact(name)
      if self.class.facts.has_key?(name)
        self.class.facts[name]
      else
        raise KeyError, "#{self.class.name} does not define fact '#{name}'!"
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def applies_if(&block)
        (@matchers ||= Set.new) << Butterfli::Regulation::Rule::Matcher.new(&block)
      end
      def matchers
        m = (@matchers ||= Set.new).dup
        if self.superclass.respond_to?(:matchers)
          self.superclass.matchers.merge(m)
        else
          m
        end
      end
      def permits_if(&block)
        (@conditions ||= Set.new) << Butterfli::Regulation::Rule::Condition.new(&block)
      end
      def conditions
        c = (@conditions ||= Set.new).dup
        if self.superclass.respond_to?(:conditions)
          self.superclass.conditions.merge(c)
        else
          c
        end
      end
      def fact(name, &block)
        (@facts ||= {})[name] = Butterfli::Regulation::Rule::Fact.new(&block)
      end
      def facts
        f = (@facts ||= {})
        if self.superclass.respond_to?(:facts)
          self.superclass.facts.merge(f)
        else
          f.dup
        end
      end
    end
  end
end