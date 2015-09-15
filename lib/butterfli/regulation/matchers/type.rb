module Butterfli::Regulation::Matchers
  module Type
    attr_accessor :type

    def self.included(base)
      base.class_eval do
        include Butterfli::Regulation::Rule

        applies_if do |rule, item|
          # Must explicitly be of the type, otherwise rule doesn't apply
          !rule.type.nil? && item.class <= rule.type
        end
      end
    end
  end
end