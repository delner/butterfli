module Butterfli::Imageable
  def self.included(base)
    base.field :images, default: Images.new
  end

  class Images < Hash
    include Butterfli::Schemable

    array :thumbnails # A URI to the original story
  end

  class Image < Hash
    include Butterfli::Schemable

    field :uri
    field :height
    field :width
  end
end