class Butterfli::Writer
  attr_accessor :write_error_block

  def initialize(options = {})
    self.write_error_block = options[:write_error_block]
  end
  def write_with_error_handling(stories)
    begin
      self.write(stories)
      true
    rescue Exception => error
      return_value = false
      if !self.write_error_block.nil?
        return_value = self.write_error_block.call(error, stories) rescue false
      end
      raise if !(error.class <= StandardError)
      return_value
    end
  end
end