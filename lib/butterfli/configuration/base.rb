module Butterfli
  module Configuration
    class Base
      include Butterfli::Configuration::Provisioning
      include Butterfli::Configuration::Syndication
      include Butterfli::Configuration::Writing
      include Butterfli::Configuration::Caching
      include Butterfli::Configuration::Processing
    end
  end

  def self.configuration
    @@configuration ||= Butterfli::Configuration::Base.new
  end
  def self.configure(&block)
    new_configuration = Butterfli::Configuration::Base.new
    block.call(new_configuration)
    @@configuration = new_configuration
  end
end
  