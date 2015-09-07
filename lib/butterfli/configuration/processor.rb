module Butterfli
  module Configuration
    class Writer
      attr_accessor :write_error_block
      def on_write_error(&block)
        self.write_error_block = block
      end
    end

    class Processor
      def writer(name, &block)
        new_writer = Butterfli::Configuration::Writers.instantiate_writer(name)
        block.call(new_writer) if !block.nil?
        self.writers << new_writer
      end
      def writers
        @writers ||= []
      end
    end

    module Processable
      def processor(name = nil, &block)
        if !name.nil?
          new_processor = Butterfli::Configuration::Processors.instantiate_processor(name)
          block.call(new_processor)
          @processor = new_processor
        else
          @processor
        end
      end
    end

    # Maintains a list of known processors which Butterfli can configure
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

require 'butterfli/configuration/syndicate_writer'
require 'butterfli/configuration/monolith_processor'
