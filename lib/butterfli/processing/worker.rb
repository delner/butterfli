module Butterfli::Processing
  class Worker
    attr_accessor :thread, :signaled_to_run, :blocking, :after_work, :sleep_interval, :obituary
    attr_accessor :work_started_block, :work_block, :work_completed_block, :work_error_block, :worker_death_block

    def initialize(work_item = nil, options = {})
      if work_item.is_a?(Hash)
        options = work_item
        work_item = nil
      end
      self.after_work = options[:after_work] || :block
      self.sleep_interval = options[:sleep_for] || 1
      if work_item
        self.work_block = work_item.work_block
        self.work_started_block = work_item.work_started_block
        self.work_completed_block = work_item.work_completed_block
        self.work_error_block = work_item.work_error_block
      else
        self.work_block = options[:on_work]
        self.work_started_block = options[:on_work_started]
        self.work_completed_block = options[:on_work_completed]
        self.work_error_block = options[:on_work_error]
      end
      self.worker_death_block = options[:on_worker_death]
      self
    end
    def alive?
      !self.thread.nil? && self.thread.alive?
    end
    def died_unexpectedly?
      !self.thread.nil? && !self.alive? && self.thread.status.nil?
    end
    def blocking?
      self.blocking == true
    end
    def stopped?
      self.thread.nil? || !self.alive?
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
          self.obituary = e
          self.worker_death_block.call(self.obituary) if self.worker_death_block
          raise
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
          self.work_started_block.call if self.work_started_block
          result = self.work_block.call
          self.work_completed_block.call(result) if self.work_completed_block
        rescue => e
          self.work_error_block.call(e) if self.work_error_block
        end
        if self.should_run?
          if self.after_work == :block
            self.blocking = true
            Thread.stop 
            self.blocking = false
          elsif self.after_work == :sleep
            sleep(self.sleep_interval)
          end
        end
      end
    end
  end
end