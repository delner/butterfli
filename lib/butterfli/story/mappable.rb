module Butterfli::Mappable
  def self.included(base)
    base.field :location, default: Location.new
  end

  class Location < Hash
    include Butterfli::Schemable

    field :lat # The latitude of where the story took place
    field :lng # The longitude of where the story took place
  end
end