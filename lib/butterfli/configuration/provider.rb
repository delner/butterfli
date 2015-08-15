module Butterfli
  module Configuration
    class Provider
    end

    # Adds methods for configuring providers to the Butterfli configuration
    module Provisionable
      def provider(name, &block)
        @providers ||= {}

        new_provider = Butterfli::Configuration::Providers.instantiate_provider(name)
        block.call(new_provider)
        @providers[name.to_sym] = new_provider
      end
      def providers(name)
        @providers ||= {}

        if @providers[name.to_sym]
          return @providers[name.to_sym]
        else
          raise "Missing provider configuration for \"#{name.to_s}\"! Did you add it to your initializer file?"
        end
      end
    end

    # Maintains a list of known providers which Butterfli can configure
    module Providers
      def self.known_providers
        @known_providers ||= {}
      end
      def self.register_provider(name, klass)
        self.known_providers[name.to_sym] = klass
      end
      def self.instantiate_provider(name)
        provider = self.known_providers[name.to_sym]
        if provider
          provider.new
        else
          raise "Unknown provider: #{name}!"
        end
      end
    end
  end
end