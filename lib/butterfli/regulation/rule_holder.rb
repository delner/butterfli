module Butterfli::Regulation
  module RuleHolder
    def rules=(rules)
      @rules = rules
    end
    def rules
      (@rules ||= Set.new)
    end
    def add_rules(*rules)
      self.rules.merge(rules.flatten)
    end
    def permits?(item)
      permitted = self.rules.inject(true) do |permitted, rule|
        permitted && (!rule.applies_to?(item) || rule.permits?(item))
      end
    end
  end
end