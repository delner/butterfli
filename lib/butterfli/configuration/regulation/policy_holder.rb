module Butterfli::Configuration::Regulation
  module PolicyHolder
    def policies_class
      Butterfli::Configuration::Regulation::Policies
    end
    def policy(name, &block)
      @policies ||= {}

      new_policy = self.policies_class.instantiate_policy(name)
      block.call(new_policy) if !block.nil?
      @policies[name] = new_policy
    end
    def policies(name = nil)
      @policies ||= {}
      if name.nil?
        @policies
      elsif @policies[name.to_sym]
        return @policies[name.to_sym]
      else
        raise "Missing policy configuration for \"#{name.to_s}\"! Did you add it to your initializer file?"
      end
    end
  end
end