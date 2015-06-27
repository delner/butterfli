module Butterfli::Describable
  def self.included(base)
    base.field :text, default: Text.new
  end

  class Text < Hash
    include Butterfli::Schemable

    field :title # A short title describing the story
    field :body # The story content
  end
end