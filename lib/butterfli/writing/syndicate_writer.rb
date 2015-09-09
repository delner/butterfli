module Butterfli::Writing
  class SyndicateWriter < Butterfli::Writing::Writer
    channel :stories do |stories|
      Butterfli.syndicate(stories)
    end
  end
end