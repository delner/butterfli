module Butterfli::Configuration::Caching
  module Caches
    def self.known_caches
      @known_caches ||= {}
    end
    def self.register_cache(name, klass)
      self.known_caches[name.to_sym] = klass
    end
    def self.instantiate_cache(name, options = {})
      cache = self.known_caches[name.to_sym]
      if cache
        cache.new
      else
        raise "Unknown cache: #{name}!"
      end
    end
  end
end