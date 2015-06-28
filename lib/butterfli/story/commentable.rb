module Butterfli::Commentable
  def self.included(base)
    base.array :comments, default: Comments.new
  end

  class Comments < Array
    include Butterfli::Schemable

    item :comment
  end
  class Comment < Hash
    include Butterfli::Schemable
    include Butterfli::Authorable
    include Butterfli::Likeable

    field :body
    field :created_date
  end
end