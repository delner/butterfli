class Butterfli::StoryJob < Butterfli::Job
  def work
    raise NoMethodError, "#{self.class.name} does not implement #get_stories!" if !self.respond_to?(:get_stories)
    stories = sanitize_stories(self.get_stories)
    self.write_stories(stories)
    return stories
  end
  def sanitize_stories(output)
    if output.class <= Array
      return output.reject { |i| !(i.class <= Butterfli::Story) }
    elsif output.class <= Butterfli::Story
      return [output]
    end
    return []
  end
  def write_stories(stories)
    return if stories.empty?
    if writers = (Butterfli.processor && Butterfli.processor.writers)
      writers.each { |w| w.write(stories) }
    end
  end
end