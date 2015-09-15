module Butterfli
  module Configuration
    module Provisioning
      def provider(name, &block)
        @providers ||= {}

        new_provider = Butterfli::Configuration::Provisioning::Providers.instantiate_provider(name)
        block.call(new_provider) if !block.nil?
        @providers[name.to_sym] = new_provider
      end
      def providers(name = nil)
        @providers ||= {}

        if name.nil?
          @providers
        elsif @providers[name.to_sym]
          return @providers[name.to_sym]
        else
          raise "Missing provider configuration for \"#{name.to_s}\"! Did you add it to your initializer file?"
        end
      end
    end
  end
end

require 'butterfli/configuration/provisioning/provider'
require 'butterfli/configuration/provisioning/providers'