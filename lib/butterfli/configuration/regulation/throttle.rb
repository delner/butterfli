module Butterfli::Configuration::Regulation
  class Throttle
    attr_accessor :max, :interval

    def instantiate
      self.instance_class.new(options)
    end
    def options
      { max: self.max, interval: self.interval }
    end
    def limit(count)
      self.max = count
    end
    def per_seconds(seconds)
      self.interval = seconds
    end
  end
end