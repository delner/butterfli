module Butterfli::Data::Schema::Likeable
  def self.included(base)
    base.array :likes, default: Likes.new
  end

  class Likes < Array
    include Butterfli::Data::Schema

    item :like
  end
  class Like < Hash
    include Butterfli::Data::Schema
    include Butterfli::Data::Schema::Authorable
  end
end