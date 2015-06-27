module Butterfli::Taggable
  def self.included(base)
    base.array :tags
  end
end