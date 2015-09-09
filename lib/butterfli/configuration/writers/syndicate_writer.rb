class Butterfli::Configuration::Writing::SyndicateWriter < Butterfli::Configuration::Writing::Writer
end

# Add it to the known writers list...
Butterfli::Configuration::Writers.register_writer(:syndicate,
                                                  Butterfli::Configuration::Writing::SyndicateWriter,
                                                  Butterfli::Writing::SyndicateWriter)