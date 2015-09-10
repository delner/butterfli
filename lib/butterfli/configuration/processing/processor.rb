module Butterfli::Configuration::Processing
  class Processor
    def instantiate
       Butterfli::Processing::Processor.new(self.instance_class.new(options))
    end
    def options
      {  }
    end
  end
end