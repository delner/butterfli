class Butterfli::Configuration::SyndicateWriter < Butterfli::Configuration::Writer
  # def initialize(options = {})
  #   super
  # end
  def instantiate
    ::Butterfli::SyndicateWriter.new(write_error_block: self.write_error_block)
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Writers.register_writer(:syndicate, Butterfli::Configuration::SyndicateWriter)