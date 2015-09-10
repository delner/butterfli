require 'spec_helper'

describe Butterfli::Data::Schema do
  describe "#schema" do
    subject { schemable_class.schema }
    context "with no fields defined" do
      let(:schemable_class) do
        stub_const 'Widget', Class.new(Hash)
        Widget.class_eval { include Butterfli::Data::Schema }
        Widget
      end
      it { expect(subject).to be_a(Hash) }
    end
    context "with fields defined" do
      let(:schemable_class) do
        stub_const 'Widget', Class.new(Hash)
        Widget.class_eval do
          include Butterfli::Data::Schema
          field :gizmo
        end
        Widget
      end
      it do
        expect(subject).to be_a(Hash)
        expect(subject).to include(:gizmo)
      end
    end
  end
  describe "#field" do
    subject { schemable_class.new }
    context "with no default" do
      let(:schemable_class) do
        stub_const 'Widget', Class.new(Hash)
        Widget.class_eval do
          include Butterfli::Data::Schema
          field :gizmo
        end
        Widget
      end
      it { expect(subject).to include(gizmo: nil) }
    end
    
    context "with a default" do
      context "that isn't cloneable" do
        [nil, false, true, 1, -2.15].each do |default_value|
          let(:schemable_class) do
            stub_const 'Widget', Class.new(Hash)
            Widget.class_eval { include Butterfli::Data::Schema }
            Widget
          end
          it do
            schemable_class.class_eval { field :gizmo, default: default_value }
            expect(subject).to include(gizmo: default_value)
            expect(subject[:gizmo].object_id).to eq(default_value.object_id)
          end
        end
      end
      context "that is cloneable" do
        # Because let blocks and class evals are stupid
        default_value = "default" 

        let(:schemable_class) do
          stub_const 'Widget', Class.new(Hash)
          Widget.class_eval do
            include Butterfli::Data::Schema
            field :gizmo, default: default_value
          end
          Widget
        end
        it do
          expect(subject).to include(gizmo: default_value)
          expect(subject[:gizmo].object_id).not_to be(default_value.object_id)
        end
      end
    end
  end
end

shared_examples "schemable" do
  describe "#schema" do
    subject { base_class.schema }
    it { expect(base_class).to respond_to(:schema) }
  end
  describe "#field" do
    subject { base_class.field }
    it { expect(base_class).to respond_to(:field) }
  end
  describe "#array" do
    subject { base_class.array }
    it { expect(base_class).to respond_to(:array) }
  end
  describe "#item" do
    subject { base_class.item }
    it { expect(base_class).to respond_to(:item) }
  end
end

shared_examples "it has a field" do |name|
  it { expect(subject).to respond_to(name) }
  it { expect(subject).to respond_to("#{name}=") }
end