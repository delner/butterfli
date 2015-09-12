module Butterfli::Processing
  module Subworkable
    # Getters
    def job_started_block
      @job_started_block
    end
    def job_completed_block
      @job_completed_block
    end
    def job_error_block
      @job_error_block
    end

    # Setters
    def on_job_started(&block)
      @job_started_block = block
    end
    def on_job_completed(&block)
      @job_completed_block = block
    end
    def on_job_error(&block)
      @job_error_block = block
    end
  end
end