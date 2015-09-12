module Butterfli::Processing
  class MonolithProcessorAdapter < Butterfli::Processing::Processor
    include Butterfli::Processing::Workable
    include Butterfli::Processing::Subworkable
    include Butterfli::Processing::WorkPool

    attr_accessor :options

    def initialize(options = {})
      super
      self.options = options
      self.setup_work_event
      self.setup_callbacks
      options[:num_workers].times do
        self.workers << Butterfli::Processing::Worker.new(self,
                                                          after_work: options[:after_work],
                                                          sleep_for: options[:sleep_for],
                                                          on_worker_death: options[:on_worker_death])
      end
      self
    end
    def queue
      @queue ||= Set.new
    end
    def mutex
      @mutex ||= Mutex.new
    end
    def enqueue(queue, job)
      queued = false
      self.mutex.synchronize do
        queued = !self.queue.add?(job).nil?
      end
      self.wakeup if queued && options[:after_work] == :block
      return queued
    end
    def dequeue(queue=nil)
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
    def setup_work_event
      self.on_work do
        completed_jobs = []
        errors = []
        while self.pending_jobs?
          job = self.dequeue
          begin
            if !job.nil?
              self.job_started_block.call(job) if self.job_started_block
              job_result = job.work
              completed_jobs << {job: job, result: job_result}
              self.job_completed_block.call(job, result)  if self.job_completed_block
            end
          rescue => error
            self.job_error_block.call(job, error) if self.job_error_block
            errors << error
          end
        end
        completed_jobs
      end
    end
    def setup_callbacks
      [ :on_job_started, :on_job_completed, :on_job_error,
        :on_work_started, :on_work_completed, :on_work_error].each do |event|
        self.send(event, &(self.options[event])) if self.options[event]
      end
    end
  end
end