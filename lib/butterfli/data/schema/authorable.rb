module Butterfli::Data::Schema::Authorable
  def self.included(base)
    base.field :author, default: Author.new
  end

  class Author < Hash
    include Butterfli::Data::Schema

    field :username # The author's username
    field :name # The author's real name
  end
end