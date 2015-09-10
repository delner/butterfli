module Butterfli::Configuration::Writing
  class SyndicateWriter < Butterfli::Configuration::Writing::Writer
    def instance_class
      Butterfli::Writing::SyndicateWriter
    end
  end
end

# Add it to the known writers list...
Butterfli::Configuration::Writing::Writers.register_writer(:syndicate, Butterfli::Configuration::Writing::SyndicateWriter)