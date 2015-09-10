module Butterfli::Configuration::Writing
  module Writers
    def self.known_writers
      @known_writers ||= {}
    end
    def self.register_writer(name, klass)
      self.known_writers[name.to_sym] = klass
    end
    def self.instantiate_writer(name, options = {})
      writer = self.known_writers[name.to_sym]
      if writer
        writer.new
      else
        raise "Unknown writer: #{name}!"
      end
    end
  end
end