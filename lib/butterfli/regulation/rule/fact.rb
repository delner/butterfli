module Butterfli::Regulation
  module Rule
    class Fact
      attr_accessor :block
      def initialize(&block)
        self.block = block
      end
      def from(*args)
        self.block.call(*args)
      end
      def read
        self.block.call
      end
    end
  end
end