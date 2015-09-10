module Butterfli::Data::Schema::Commentable
  def self.included(base)
    base.array :comments, default: Comments.new
  end

  class Comments < Array
    include Butterfli::Data::Schema

    item :comment
  end
  class Comment < Hash
    include Butterfli::Data::Schema
    include Butterfli::Data::Schema::Authorable
    include Butterfli::Data::Schema::Likeable

    field :body
    field :created_date
  end
end