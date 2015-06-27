module Butterfli::Shareable
  def self.included(base)
    base.array :shares, default: Shares.new
  end

  class Shares < Array
    include Butterfli::Schemable

    item :share
  end
  class Share < Hash
    include Butterfli::Schemable
    include Butterfli::Authorable
  end
end