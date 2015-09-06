class Butterfli::Worker
  attr_accessor :thread, :signaled_to_run, :blocking, :after_cycle, :sleep_interval, :obituary
  attr_accessor :work_started_block, :work_completed_block, :work_error_block

  def initialize(work_item = nil, options = {})
    if work_item.is_a?(Hash)
      options = work_item
      work_item = nil
    end
    self.after_cycle = options[:after_cycle] || :block
    self.sleep_interval = options[:sleep_for] || 1
    if work_item
      self.work_started_block = work_item.work_started_block
      self.work_completed_block = work_item.work_completed_block
      self.work_error_block = work_item.work_error_block
    else
      self.work_started_block = options[:on_work_started]
      self.work_completed_block = options[:on_work_completed]
      self.work_error_block = options[:on_work_error]
    end
  end
  def alive?
    !self.thread.nil? && self.thread.alive?
  end
  def died_unexpectedly?
    !self.thread.alive? && self.thread.status.nil?
  end
  def blocking?
    self.blocking == true
  end
  def should_run?
    self.signaled_to_run == true
  end
  def start
    return false if self.alive?
    self.signaled_to_run = true
    self.thread = Thread.new do
      begin
        self.process; Thread.exit
      rescue Exception => e
        self.obituary = e; raise
      end
    end
    return true
  end
  def wakeup
    if self.alive? && self.blocking?
      self.thread.wakeup
      return true
    else
      return false
    end
  end
  def stop
    return false if !self.should_run?
    self.signaled_to_run = false
    # If it's blocking (waiting for a signal),
    # try signaling to gracefully stop. 
    self.wakeup if self.blocking?
    return true
  end
  def kill
    if self.alive?
      self.stop
      self.thread.kill
      self.blocking = false
      return true
    else
      return false
    end
  end
  def process
    while self.should_run? do
      begin
        result = self.work_started_block.call(self)
        self.work_completed_block.call(self, result) if self.work_completed_block
      rescue => e
        self.work_error_block.call(self, e) if self.work_error_block
      end
      if self.should_run?
        if self.after_cycle == :block
          self.blocking = true
          Thread.stop 
          self.blocking = false
        elsif self.after_cycle == :sleep
          sleep(self.sleep_interval)
        end
      end
    end
  end
end