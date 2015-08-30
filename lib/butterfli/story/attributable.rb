module Butterfli::Attributable
  def self.included(base)
    base.field :references, default: References.new
  end

  class References < Hash
    include Butterfli::Schemable

    field :source_uri # A URI to the original story
    field :source_id # A source-defined object ID
    field :source_type # A source-defined object type
  end
end