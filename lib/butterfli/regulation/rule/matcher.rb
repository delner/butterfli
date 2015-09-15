module Butterfli::Regulation
  module Rule
    class Matcher
      attr_accessor :block
      def initialize(&block)
        self.block = block
      end
      def call(*args)
        self.block.call(*args)
      end
    end
  end
end