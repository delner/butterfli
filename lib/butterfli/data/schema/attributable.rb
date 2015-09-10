module Butterfli::Data::Schema::Attributable
  def self.included(base)
    base.field :references, default: References.new
  end

  class References < Hash
    include Butterfli::Data::Schema

    field :source_uri # A URI to the original story
  end
end