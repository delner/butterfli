class Butterfli::Configuration::MonolithProcessor < Butterfli::Configuration::Processor
  attr_accessor :after_work, :sleep_for, :num_workers

  def options
    super.merge({
        after_work: (self.after_work || :block),
        sleep_for: (self.sleep_for || 5),
        num_workers: (self.num_workers || 1)
      })
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Processors.register_processor(:monolith,
                                                        Butterfli::Configuration::MonolithProcessor,
                                                        Butterfli::MonolithProcessor)