require 'spec_helper'

describe Butterfli do
  context "with caching" do
    it { expect(subject).to respond_to(:cache) }
  end
end