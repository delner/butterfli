module Butterfli::Configuration::Caching
  class MemoryCache < Butterfli::Configuration::Caching::Cache
    def instance_class
      Butterfli::Caching::MemoryCacheAdapter
    end
  end
end

# Add it to the known caches list...
Butterfli::Configuration::Caching::Caches.register_cache(:memory, Butterfli::Configuration::Caching::MemoryCache)