class Butterfli::Story < Hash
  include Butterfli::Schemable
  include Butterfli::Attributable
  include Butterfli::Describable
  include Butterfli::Authorable
  include Butterfli::Taggable
  include Butterfli::Commentable
  include Butterfli::Shareable
  include Butterfli::Likeable
  include Butterfli::Imageable
  include Butterfli::Mappable
  include Butterfli::Identifiable

  field :type # The kind of story (e.g. :post, :photo, :video)
  field :created_date # Time the story occurred

  def id
    self[:id] ||= SecureRandom.hex(8)
  end
end