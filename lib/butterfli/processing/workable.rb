module Butterfli::Processing
  module Workable
    # Getters
    def work_started_block
      @work_started_block
    end
    def work_completed_block
      @work_completed_block
    end
    def work_error_block
      @work_error_block
    end

    # Setters
    def on_work_started(&block)
      @work_started_block = block
    end
    def on_work_completed(&block)
      @work_completed_block = block
    end
    def on_work_error(&block)
      @work_error_block = block
    end
  end
end