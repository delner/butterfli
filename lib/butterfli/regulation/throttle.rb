module Butterfli::Regulation
  class Throttle
    include Butterfli::Regulation::Rule
    include Butterfli::Regulation::Conditions::Rate

    def initialize(options = {})
      self.max = options[:max]
      self.interval = options[:interval]
    end
  end
end