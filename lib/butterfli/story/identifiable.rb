module Butterfli::Identifiable
  def self.included(base)
    base.field :source, default: Identity.new
  end

  class Identity < Hash
    include Butterfli::Schemable

    field :name # Name of the source it came from (:twitter, :facebook)
    field :id # A source-defined object ID
    field :type # A source-defined object type

    def key
      Digest::SHA256.hexdigest "#{self.name.to_s}:#{self.type.to_s}:#{self.id.to_s}"
    end
  end
end