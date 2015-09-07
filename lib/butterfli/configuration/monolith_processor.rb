class Butterfli::Configuration::MonolithProcessor < Butterfli::Configuration::Processor
  attr_accessor :after_work, :sleep_for, :num_workers

  def initialize
    self.after_work ||= :block
    self.sleep_for ||= 5
    self.num_workers ||= 1
  end
  def instantiate
    ::Butterfli::MonolithProcessor.new( after_work: self.after_work,
                                        sleep_for: self.sleep_for,
                                        num_workers: self.num_workers,
                                        writers: self.writers.collect { |w| w.instantiate })
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Processors.register_processor(:monolith, Butterfli::Configuration::MonolithProcessor)