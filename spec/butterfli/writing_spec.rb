require 'spec_helper'

describe Butterfli do
  context "with writing" do
    it { expect(subject).to respond_to(:writers) }
  end
end