class Butterfli::Data::Story < Hash
  include Butterfli::Data::Schema
  include Butterfli::Data::Schema::Attributable
  include Butterfli::Data::Schema::Describable
  include Butterfli::Data::Schema::Authorable
  include Butterfli::Data::Schema::Taggable
  include Butterfli::Data::Schema::Commentable
  include Butterfli::Data::Schema::Shareable
  include Butterfli::Data::Schema::Likeable
  include Butterfli::Data::Schema::Imageable
  include Butterfli::Data::Schema::Mappable
  include Butterfli::Data::Schema::Identifiable

  field :type # The kind of story (e.g. :post, :photo, :video)
  field :created_date # Time the story occurred

  def id
    self[:id] ||= SecureRandom.hex(8)
  end
end