require 'butterfli/configuration/provisioning'
require 'butterfli/configuration/observing'
require 'butterfli/configuration/writing'
require 'butterfli/configuration/caching'
require 'butterfli/configuration/processing'

module Butterfli
  def self.configuration
    @@configuration ||= Butterfli::Configuration::Base.new
  end
  def self.configure(&block)
    new_configuration = Butterfli::Configuration::Base.new
    block.call(new_configuration)
    @@configuration = new_configuration
  end

  module Configuration
    class Base
      include Butterfli::Configuration::Provisioning
      include Butterfli::Configuration::Observing
      include Butterfli::Configuration::Writing
      include Butterfli::Configuration::Processing
    end
  end
end
  