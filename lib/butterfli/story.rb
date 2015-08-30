class Butterfli::Story < Hash
  include Butterfli::Schemable
  include Butterfli::Attributable
  include Butterfli::Describable
  include Butterfli::Authorable  # NEW
  include Butterfli::Taggable  # NEW
  include Butterfli::Commentable  # NEW
  include Butterfli::Shareable  # NEW 
  include Butterfli::Likeable # NEW
  include Butterfli::Imageable
  include Butterfli::Mappable

  field :type # The kind of story (e.g. :post, :photo, :video)
  field :source # Name of the source it came from (:twitter, :facebook)
  field :created_date # Time the story occurred

  def id
    self[:id] ||= SecureRandom.hex(8)
  end
  def source_key
    Digest::SHA256.hexdigest "#{self.source.to_s}:#{self.references.source_type.to_s}:#{self.references.source_id.to_s}"
  end
end