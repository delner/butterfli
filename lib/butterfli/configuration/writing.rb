module Butterfli
  module Configuration
    module Writing
      def writer(name, &block)
        new_writer = Butterfli::Configuration::Writing::Writers.instantiate_writer(name)
        block.call(new_writer) if !block.nil?
        self.writers << new_writer
      end
      def writers
        @writers ||= []
      end
    end
  end
end

require 'butterfli/configuration/writing/writer'
require 'butterfli/configuration/writing/writers'

require 'butterfli/configuration/writing/syndicate_writer'