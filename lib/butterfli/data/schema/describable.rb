module Butterfli::Data::Schema::Describable
  def self.included(base)
    base.field :text, default: Text.new
  end

  class Text < Hash
    include Butterfli::Data::Schema

    field :title # A short title describing the story
    field :body # The story content
  end
end