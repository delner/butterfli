require 'butterfli/syndication/observable'

module Butterfli::Syndication
  def self.included(base)
    base.class_eval { include Butterfli::Syndication::Observable }
  end
end

# Inject module into the global namespace
Butterfli.class_eval do
  include Butterfli::Syndication
end