module Butterfli
  module Configuration
    module Caching
      def cache(name = nil, &block)
        if !name.nil?
          new_cache = Butterfli::Configuration::Caching::Caches.instantiate_cache(name)
          block.call(new_cache) if !block.nil?
          @cache = new_cache
        else
          @cache
        end
      end
    end
  end
end

require 'butterfli/configuration/caching/cache'
require 'butterfli/configuration/caching/caches'

require 'butterfli/configuration/caching/memory_cache'