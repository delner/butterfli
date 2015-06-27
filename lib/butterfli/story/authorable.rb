module Butterfli::Authorable
  def self.included(base)
    base.field :author, default: Author.new
  end

  class Author < Hash
    include Butterfli::Schemable

    field :username # The author's username
    field :name # The author's real name
  end
end