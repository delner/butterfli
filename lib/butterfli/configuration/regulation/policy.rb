module Butterfli::Configuration::Regulation
  class Policy
    include Butterfli::Configuration::Regulation::RuleHolder

    def instantiate
      self.instance_class.new(options)
    end
    def options
      { rules: self.rules.collect { |r| r.instantiate } }
    end
  end
end