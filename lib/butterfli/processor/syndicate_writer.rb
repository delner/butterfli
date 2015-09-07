class Butterfli::SyndicateWriter < Butterfli::Writer
  def write(stories)
    Butterfli.syndicate(stories)
  end
end