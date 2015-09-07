module Butterfli::Writing
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def writers=(w)
      @writers = w
    end
    def writers
      return @writers || (self.writers = ( Butterfli.configuration.writers && Butterfli.configuration.writers.collect { |w| w.instantiate }))
    end
  end
end

# Inject module into the global namespace
Butterfli.class_eval { include Butterfli::Writing }