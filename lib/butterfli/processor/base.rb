module Butterfli
  module Processor
    class Base
      attr_accessor :writers

      def initialize(options = {})
        self.writers = options[:writers] || []
      end
    end
  end
end