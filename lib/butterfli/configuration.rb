
module Butterfli
  def self.configuration
    @@configuration ||= Butterfli::Configuration.new
  end
  def self.configure(&block)
    new_configuration = Butterfli::Configuration.new
    block.call(new_configuration)
    @@configuration = new_configuration
  end
  class Configuration
  end
end
  