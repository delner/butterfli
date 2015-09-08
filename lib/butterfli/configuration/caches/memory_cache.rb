class Butterfli::Configuration::MemoryCache < Butterfli::Configuration::Cache
end

# Add it to the known caches list...
Butterfli::Configuration::Caches.register_cache(:memory,
                                                Butterfli::Configuration::MemoryCache,
                                                Butterfli::MemoryCacheAdapter)