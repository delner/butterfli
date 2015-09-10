module Butterfli::Data::Schema::Taggable
  def self.included(base)
    base.array :tags
  end
end