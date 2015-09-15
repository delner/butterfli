module Butterfli::Configuration::Regulation
  module Policies
    def self.known_policies
      @known_policies ||= {}
    end
    def self.register_policy(name, klass)
      self.known_policies[name.to_sym] = klass
    end
    def self.instantiate_policy(name, options = {})
      policy = self.known_policies[name.to_sym]
      if policy
        policy.new
      else
        raise "Unknown policy: #{name}!"
      end
    end
  end
end