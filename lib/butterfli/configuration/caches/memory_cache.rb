class Butterfli::Configuration::MemoryCache < Butterfli::Configuration::Cache
  def instance_class
    Butterfli::MemoryCacheAdapter
  end
end

# Add it to the known caches list...
Butterfli::Configuration::Caches.register_cache(:memory, Butterfli::Configuration::MemoryCache)