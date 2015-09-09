class Butterfli::Configuration::Writing::SyndicateWriter < Butterfli::Configuration::Writing::Writer
  def instance_class
    Butterfli::Writing::SyndicateWriter
  end
end

# Add it to the known writers list...
Butterfli::Configuration::Writers.register_writer(:syndicate, Butterfli::Configuration::Writing::SyndicateWriter)