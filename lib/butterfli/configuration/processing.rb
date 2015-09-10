module Butterfli
  module Configuration
    module Processing
      def processor(name = nil, &block)
        if !name.nil?
          new_processor = Butterfli::Configuration::Processing::Processors.instantiate_processor(name)
          block.call(new_processor) if !block.nil?
          @processor = new_processor
        else
          @processor
        end
      end
    end
  end
end

require 'butterfli/configuration/processing/processor'
require 'butterfli/configuration/processing/processors'

require 'butterfli/configuration/processing/monolith_processor'