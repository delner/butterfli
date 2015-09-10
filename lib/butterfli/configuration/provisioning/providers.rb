module Butterfli::Configuration::Provisioning
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