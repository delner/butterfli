class Butterfli::Cache
  attr_accessor :adapter
  def initialize(adapter)
    self.adapter = adapter
  end

  def read(key)
    self.adapter.read(key)
  end
  def write(key, value)
    self.adapter.write(key, value)
  end
  def fetch(key, value = nil, &block)
    self.adapter.fetch(key, value, &block)
  end
  def delete(key)
    self.adapter.delete(key)
  end
  def clear
    self.adapter.clear
  end
  def has_key?(key)
    self.adapter.has_key?(key)
  end
  def empty?
    self.adapter.empty?
  end
end