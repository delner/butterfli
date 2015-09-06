module Butterfli::Processing
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def processor=(p)
      @processor = p
    end
    def processor
      return @processor || (self.processor = ( Butterfli.configuration.processor && Butterfli.configuration.processor.instantiate))
    end
  end
end

# Inject module into the global namespace
Butterfli.class_eval { include Butterfli::Processing }