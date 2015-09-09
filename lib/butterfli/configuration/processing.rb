module Butterfli
  module Configuration
    class Processor
      def instantiate
        self.instance_class.new(options)
      end
      def options
        {  }
      end
    end

    module Processing
      def processor(name = nil, &block)
        if !name.nil?
          new_processor = Butterfli::Configuration::Processors.instantiate_processor(name)
          block.call(new_processor) if !block.nil?
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
  end
end
