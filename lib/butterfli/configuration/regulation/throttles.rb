module Butterfli::Configuration::Regulation
  module Throttles
    def self.known_throttles
      @known_throttles ||= {}
    end
    def self.register_throttle(name, klass)
      self.known_throttles[name.to_sym] = klass
    end
    def self.instantiate_throttle(name, options = {})
      throttle = self.known_throttles[name.to_sym]
      if throttle
        throttle.new
      else
        raise "Unknown throttle: #{name}!"
      end
    end
  end
end