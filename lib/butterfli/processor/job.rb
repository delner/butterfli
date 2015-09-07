class Butterfli::Job
  attr_accessor :args
  def initialize(args = {})
    self.args = args.empty? ? (self.args ||= {}) : args
  end
  def hash
    [self.class.name, self.args].hash
  end
  def eql?(other)
    self.hash == other.hash
  end
end