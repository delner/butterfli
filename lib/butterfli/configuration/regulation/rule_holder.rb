module Butterfli::Configuration::Regulation
  module RuleHolder
    def throttles_class
      Butterfli::Configuration::Regulation::Throttles
    end
    def rules
      self.throttles
    end
    def throttle(name, &block)
      new_throttle = self.throttles_class.instantiate_throttle(name)
      block.call(new_throttle) if !block.nil?
      self.throttles << new_throttle
    end
    def throttles
      @throttles ||= []
    end
  end
end