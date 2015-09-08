class Butterfli::MemoryCacheAdapter
  attr_accessor :memory_cache
  def initialize(options = {})
    self.memory_cache = {}
  end

  def read(key)
    self.memory_cache[key]
  end
  def write(key, value)
    self.memory_cache[key] = value
  end
  def fetch(key, value = nil, &block)
    self.memory_cache.has_key?(key) ? self.memory_cache[key] : (self.memory_cache[key] = (value || block.call))
  end
  def delete(key)
    self.memory_cache.delete(key)
  end
  def clear
    self.memory_cache.clear
  end
  def has_key?(key)
    self.memory_cache.has_key?(key)
  end
  def empty?
    self.memory_cache.empty?
  end
end