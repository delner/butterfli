require 'butterfli/caching/cache'

require 'butterfli/caching/memory_cache_adapter'

module Butterfli::Caching
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def cache=(p)
      @cache = p
    end
    def cache
      return @cache || (self.cache = default_cache)
    end

    private
    def default_cache
      (Butterfli.configuration.cache && Butterfli.configuration.cache.instantiate) || Butterfli::Configuration::Caching::MemoryCache.new.instantiate
    end
  end
end

# Inject module into the global namespace
Butterfli.class_eval { include Butterfli::Caching }