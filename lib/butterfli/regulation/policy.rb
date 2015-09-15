module Butterfli::Regulation
  class Policy
    include Butterfli::Regulation::RuleHolder
    def initialize(options = {})
      self.rules = options[:rules]
    end
  end
end