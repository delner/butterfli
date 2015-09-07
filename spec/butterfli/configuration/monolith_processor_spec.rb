require 'spec_helper'

describe Butterfli::Configuration::MonolithProcessor do
  context "when configured in Butterfli" do
    let(:after_work) { :block }
    let(:num_workers) { 1 }
    let(:sleep_for) { 5 }
    before do
      Butterfli.configure do |config|
        config.processor :monolith do |processor|
          processor.after_work = after_work
          processor.num_workers = num_workers
          processor.sleep_for = sleep_for
        end
      end
    end
    subject { Butterfli.processor }
    it do
      expect(subject).to be_a_kind_of(Butterfli::MonolithProcessor)
      expect(subject.workers.first.after_work).to eq(after_work)
      expect(subject.workers.first.sleep_interval).to eq(sleep_for)
      expect(subject.workers.length).to eq(num_workers)
    end
  end
end