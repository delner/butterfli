require 'butterfli/configuration/provider'
require 'butterfli/configuration/observable'

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
      include Butterfli::Configuration::Provisionable
      include Butterfli::Configuration::Observable
    end
  end
end
  