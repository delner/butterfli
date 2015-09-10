module Butterfli::Configuration::Processing
  class MonolithProcessor < Butterfli::Configuration::Processing::Processor
    attr_accessor :after_work, :sleep_for, :num_workers
    def instance_class
      Butterfli::Processing::MonolithProcessor
    end
    def options
      super.merge({
          after_work: (self.after_work || :block),
          sleep_for: (self.sleep_for || 5),
          num_workers: (self.num_workers || 1)
        })
    end
  end
end

# Add it to the known processors list...
Butterfli::Configuration::Processing::Processors.register_processor(:monolith, Butterfli::Configuration::Processing::MonolithProcessor)