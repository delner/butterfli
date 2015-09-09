module Butterfli
  module Configuration
    module Writing
      def writer(name, &block)
        new_writer = Butterfli::Configuration::Writers.instantiate_writer(name)
        block.call(new_writer) if !block.nil?
        self.writers << new_writer
      end
      def writers
        @writers ||= []
      end

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

    # Maintains a list of known writers which Butterfli can configure
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
end