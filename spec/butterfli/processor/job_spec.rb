require 'spec_helper'

describe Butterfli::Job do
  subject { Butterfli::Job }
  context "instance" do
    subject { super().new }
    it { expect(subject).to respond_to(:args) }
  end
  context "given two instances" do
    let(:job_class_one) do
      stub_const 'JobOne', Class.new(Butterfli::Job)
      JobOne
    end
    let(:job_class_two) do
      stub_const 'JobTwo', Class.new(Butterfli::Job)
      JobTwo
    end
    context "of the same class" do
      context "and the same arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_one.new(value: 1) }
        it do
          expect(job_one.hash).to eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be true
        end
      end
      context "and different arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_one.new(value: 2) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
    end
    context "of different classes" do
      context "and the same arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_two.new(value: 1) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
      context "and different arguments" do
        let(:job_one) { job_class_one.new(value: 1) }
        let(:job_two) { job_class_two.new(value: 2) }
        it do
          expect(job_one.hash).to_not eq(job_two.hash)
          expect(job_one.eql?(job_two)).to be false
        end
      end
    end
  end
end