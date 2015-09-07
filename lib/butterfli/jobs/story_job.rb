class Butterfli::StoryJob < Butterfli::Job
  def do_work
    raise NoMethodError, "#{self.class.name} does not implement #get_stories!" if !self.respond_to?(:get_stories)
    stories = sanitize_stories(self.get_stories)
    stories
  end
  def sanitize_stories(output)
    if output.class <= Array
      output.reject { |i| !(i.class <= Butterfli::Story) }
    elsif output.class <= Butterfli::Story
      [output]
    else
      []
    end
  end
end