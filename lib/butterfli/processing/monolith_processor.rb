module Butterfli::Processing
  class MonolithProcessor < Butterfli::Processing::Processor
    include Butterfli::Processing::Workable
    include Butterfli::Processing::WorkPool

    def initialize(options = {})
      super
      self.setup_work_events
      options[:num_workers].times do
        self.workers << Butterfli::Processing::Worker.new(self, after_work: options[:after_work], sleep_for: options[:sleep_for])
      end
      self
    end
    def queue
      @queue ||= Set.new
    end
    def mutex
      @mutex ||= Mutex.new
    end
    def enqueue(job)
      queued = false
      self.mutex.synchronize do
        queued = !self.queue.add?(job).nil?
      end
      self.wakeup if queued
      return queued
    end
    def dequeue
      item = nil
      self.mutex.synchronize do
        if !self.queue.empty?
          self.queue.delete(item = self.queue.first)
        end
      end
      item
    end
    def pending_jobs?
      self.mutex.synchronize do
        !self.queue.empty?
      end
    end
    def setup_work_events
      self.on_work_started do
        completed_jobs = []
        while self.pending_jobs?
          job = self.dequeue
          begin
            completed_jobs << job.work if !job.nil?
          rescue => error
            puts "Job failed!: #{error.message} #{error.backtrace}"
          end
        end
        completed_jobs
      end
      self.on_work_completed do |worker, completed_jobs|
        # puts "Completed #{completed_jobs.length} jobs."
      end
      self.on_work_error do |worker, error|
        # puts "Failed to process jobs! Error: #{error.message} #{error.backtrace}"
      end
    end
  end
end