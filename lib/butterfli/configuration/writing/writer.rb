module Butterfli::Configuration::Writing
  class Writer
    attr_accessor :write_error_block
    def instantiate
      self.instance_class.new(options)
    end
    def options
      { write_error_block: self.write_error_block }
    end
    def on_write_error(&block)
      self.write_error_block = block
    end
  end
end