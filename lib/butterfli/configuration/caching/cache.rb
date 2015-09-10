module Butterfli::Configuration::Caching
  class Cache
    def instantiate
      Butterfli::Caching::Cache.new(self.instance_class.new(options))
    end
    def options
      { }
    end
  end
end