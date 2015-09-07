class Butterfli::Writer
  attr_accessor :write_error_block

  def initialize(options = {})
    self.write_error_block = options[:write_error_block]
  end
  def write_with_error_handling(output)
    begin
      self.write(output)
      true
    rescue Exception => error
      return_value = false
      if !self.write_error_block.nil?
        return_value = self.write_error_block.call(error, output) rescue false
      end
      raise if !(error.class <= StandardError)
      return_value
    end
  end
  def are_stories?(output)
    if output.class <= Butterfli::Story || (output.class <= Array && output.all? { |i| i.class <= Butterfli::Story })
      true
    else
      false
    end
  end
end