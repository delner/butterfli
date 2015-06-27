module Butterfli::Likeable
  def self.included(base)
    base.array :likes, default: Likes.new
  end

  class Likes < Array
    include Butterfli::Schemable

    item :like
  end
  class Like < Hash
    include Butterfli::Schemable
    include Butterfli::Authorable
  end
end