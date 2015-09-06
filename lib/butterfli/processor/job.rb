class Butterfli::Job
  attr_accessor :args
  def initialize(args = {})
    self.args = args
  end
  def hash
    [self.class.name, self.args].hash
  end
end