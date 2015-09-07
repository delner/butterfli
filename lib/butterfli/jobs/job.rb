class Butterfli::Job
  # Class
  def self.before_work(&block)
    (@before_work_callbacks ||= Set.new) << block
  end
  def self.after_work(&block)
    (@after_work_callbacks ||= Set.new) << block
  end
  def self.before_work_callbacks
    callbacks = (@before_work_callbacks ||= Set.new).dup
    if self.superclass.respond_to?(:before_work_callbacks)
      self.superclass.before_work_callbacks.merge(callbacks)
    else
      callbacks
    end
  end
  def self.after_work_callbacks
    callbacks = (@after_work_callbacks ||= Set.new).dup
    if self.superclass.respond_to?(:after_work_callbacks)
      self.superclass.after_work_callbacks.merge(callbacks)
    else
      callbacks
    end
  end
  def self.reset_all_callbacks!
    @before_work_callbacks = Set.new
    @after_work_callbacks = Set.new
  end

  # Instance
  attr_accessor :args, :before_work_callbacks, :after_work_callbacks

  def initialize(args = {})
    self.args = args.empty? ? (self.args ||= {}) : args
    self.before_work_callbacks = self.class.before_work_callbacks
    self.after_work_callbacks = self.class.after_work_callbacks
  end
  def hash
    [self.class.name, self.args].hash
  end
  def eql?(other)
    self.hash == other.hash
  end
  def work
    raise NoMethodError, "#{self.class.name} does not implement #do_work!" if !self.respond_to?(:do_work)
    do_before_work_callbacks
    result = do_work
    do_after_work_callbacks(result)
    result
  end
  def do_before_work_callbacks
    self.before_work_callbacks.each { |c| c.call }
  end
  def do_after_work_callbacks(result)
    self.after_work_callbacks.each { |c| c.call(result) }
  end
end