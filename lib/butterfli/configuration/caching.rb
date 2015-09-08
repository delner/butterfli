module Butterfli
  module Configuration
    class Cache
      attr_accessor :instance_class
      def initialize(options = {})
        self.instance_class = options[:instance_class]
      end
      def instantiate
        Butterfli::Cache.new(self.instance_class.new(options))
      end
      def options
        { }
      end
    end

    module Writing
      def cache(name = nil, &block)
        if !name.nil?
          new_cache = Butterfli::Configuration::Caches.instantiate_cache(name)
          block.call(new_cache) if !block.nil?
          @cache = new_cache
        else
          @cache
        end
      end
    end

    # Maintains a list of known caches which Butterfli can configure
    module Caches
      def self.known_caches
        @known_caches ||= {}
      end
      def self.register_cache(name, config_class, instance_class)
        self.known_caches[name.to_sym] = { configuration: config_class, instance: instance_class }
      end
      def self.instantiate_cache(name, options = {})
        cache = self.known_caches[name.to_sym]
        if cache
          cache[:configuration].new(instance_class: cache[:instance])
        else
          raise "Unknown cache: #{name}!"
        end
      end
    end
  end
end