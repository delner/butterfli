module Butterfli
  module Configuration
    module Observable
      def filter_duplicates_with_memory_cache
        @filter_duplicates_with_memory_cache ||= false
      end
      def filter_duplicates_with_memory_cache=(value)
        @filter_duplicates_with_memory_cache = value
      end
      def memory_cache_filter_max_size
        @memory_cache_filter_max_size ||= 1000
      end
      def memory_cache_filter_max_size=(value)
        @memory_cache_filter_max_size = value
      end
    end
  end
end