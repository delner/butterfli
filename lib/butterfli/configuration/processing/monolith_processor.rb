module Butterfli::Configuration::Processing
  class MonolithProcessor < Butterfli::Configuration::Processing::Processor
    attr_accessor :after_work, :sleep_for, :num_workers

    def on_job_started(&block)
      @job_started_block = block
    end
    def on_job_completed(&block)
      @job_completed_block = block
    end
    def on_job_error(&block)
      @job_error_block = block
    end
    def on_work_started(&block)
      @work_started_block = block
    end
    def on_work_completed(&block)
      @work_completed_block = block
    end
    def on_work_error(&block)
      @work_error_block = block
    end
    def on_worker_death(&block)
      @worker_death_block = block
    end

    def instance_class
      Butterfli::Processing::MonolithProcessorAdapter
    end
    def options
      super.merge({
          after_work: (self.after_work || :block),
          sleep_for: (self.sleep_for || 5),
          num_workers: (self.num_workers || 1),
          on_job_started: @job_started_block,
          on_job_completed: @job_completed_block,
          on_job_error: @job_error_block,
          on_work_started: @work_started_block,
          on_work_completed: @work_completed_block,
          on_work_error: @work_error_block,
          on_worker_death: @worker_death_block
        })
    end
  end
end

# Add it to the known processors list...
Butterfli::Configuration::Processing::Processors.register_processor(:monolith, Butterfli::Configuration::Processing::MonolithProcessor)