module Butterfli::Data::Schema::Shareable
  def self.included(base)
    base.array :shares, default: Shares.new
  end

  class Shares < Array
    include Butterfli::Data::Schema

    item :share
  end
  class Share < Hash
    include Butterfli::Data::Schema
    include Butterfli::Data::Schema::Authorable
  end
end