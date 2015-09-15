module Butterfli::Regulation
  module PolicyHolder
    def policies=(policies)
      @policies = policies
    end
    def policies
      (@policies ||= {})
    end
    def add_policy(name, policy)
      self.policies[name] = policy
    end
  end
end