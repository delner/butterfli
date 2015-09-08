class Butterfli::Configuration::SyndicateWriter < Butterfli::Configuration::Writer
end

# Add it to the known writers list...
Butterfli::Configuration::Writers.register_writer(:syndicate,
                                                  Butterfli::Configuration::SyndicateWriter,
                                                  Butterfli::SyndicateWriter)