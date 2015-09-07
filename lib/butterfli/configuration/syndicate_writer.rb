class Butterfli::Configuration::SyndicateWriter < Butterfli::Configuration::Processor
  def instantiate
    ::Butterfli::SyndicateWriter.new
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Writers.register_writer(:syndicate, Butterfli::Configuration::SyndicateWriter)