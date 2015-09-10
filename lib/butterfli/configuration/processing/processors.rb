module Butterfli::Configuration::Processing
  module Processors
    def self.known_processors
      @known_processors ||= {}
    end
    def self.register_processor(name, klass)
      self.known_processors[name.to_sym] = klass
    end
    def self.instantiate_processor(name, options = {})
      processor = self.known_processors[name.to_sym]
      if processor
        processor.new
      else
        raise "Unknown processor: #{name}!"
      end
    end
  end
end