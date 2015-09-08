module Butterfli::Caching
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def cache=(p)
      @cache = p
    end
    def cache
      return @cache || (self.cache = ( Butterfli.configuration.cache && Butterfli.configuration.cache.instantiate))
    end
  end
end

# Inject module into the global namespace
Butterfli.class_eval { include Butterfli::Caching }