class Butterfli::SyndicateWriter < Butterfli::Writer
  def write(output)
    Butterfli.syndicate(output) if are_stories?(output)
  end
end