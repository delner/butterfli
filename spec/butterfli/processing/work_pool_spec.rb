require 'spec_helper'

RSpec.shared_examples "a multicasted work pool method" do |method|
  subject { super().send(method) }
  context "when a worker has been added" do
    before(:each) { work_pool_instance.workers << worker }
    it { expect(worker).to receive(method).exactly(1).times; subject }
  end
end

describe Butterfli::WorkPool do
  let(:work_pool_class) do
    stub_const 'ItemProcessor', Class.new
    ItemProcessor.class_eval { include Butterfli::WorkPool }
    ItemProcessor
  end
  subject { work_pool_class }

  context "instance" do
    let(:work_pool_instance) { work_pool_class.new }
    let(:worker) { double('worker') }
    subject { work_pool_instance }

    describe "#workers" do
      subject { super().workers }
      context "when no workers have been added" do
        it { expect(subject).to eq([]) }
      end
      context "when a worker has been added" do
        before(:each) { work_pool_instance.workers << worker }
        it { expect(subject).to eq([worker])}
      end
    end
    describe "#start" do
      it_behaves_like "a multicasted work pool method", :start
    end
    describe "#wakeup" do
      it_behaves_like "a multicasted work pool method", :wakeup
    end
    describe "#stop" do
      it_behaves_like "a multicasted work pool method", :stop
    end
    describe "#kill" do
      it_behaves_like "a multicasted work pool method", :kill
    end
    describe "#alive?" do
      it_behaves_like "a multicasted work pool method", :alive?
    end
    describe "#blocking?" do
      it_behaves_like "a multicasted work pool method", :blocking?
    end
    describe "#stopped?" do
      it_behaves_like "a multicasted work pool method", :stopped?
    end
  end
end