module Butterfli
  module Configuration
    class Processor
      attr_accessor :instance_class
      def initialize(options = {})
        self.instance_class = options[:instance_class]
      end
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
      def self.register_processor(name, config_class, instance_class)
        self.known_processors[name.to_sym] = { configuration: config_class, instance: instance_class }
      end
      def self.instantiate_processor(name, options = {})
        processor = self.known_processors[name.to_sym]
        if processor
          processor[:configuration].new(instance_class: processor[:instance])
        else
          raise "Unknown processor: #{name}!"
        end
      end
    end
  end
end
