module Butterfli::Imageable
  def self.included(base)
    base.field :images, default: Images.new
  end

  class Images < Hash
    include Butterfli::Schemable

    field :thumbnail # A URI to a thumbnail for the story
    field :small # A URI to a small image for the story
    field :full # A URI to the full image for the story
  end

  class Image < Hash
    include Butterfli::Schemable

    field :uri
    field :height
    field :width
  end
end