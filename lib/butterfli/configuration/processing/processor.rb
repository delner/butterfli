module Butterfli::Configuration::Processing
  class Processor
    def instantiate
      self.instance_class.new(options)
    end
    def options
      {  }
    end
  end
end