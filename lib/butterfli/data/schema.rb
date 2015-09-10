module Butterfli::Data::Schema
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def schema
      (@schema ||= {})
    end

    # Adds a field to the schema and defines getter/setters
    def field(name, options = {})
      self.define_field(:field, name, options)
    end

    def item(name, options = {})
      self.schema[name.to_sym] = { field_type: :item }.merge(options)
      # We don't need to define helper methods here...
    end

    def array(name, options = {})
      self.define_field(:array, name, options)
    end

    protected
    def define_field(field_type, name, options = {})
      self.schema[name.to_sym] = { field_type: field_type }.merge(options)
      self.send :define_method, name do
        self[name]
      end
      self.send :define_method, "#{name}=" do |value|
        self[name] = value
      end
    end
  end

  def initialize
    initialize_with_defaults
  end

  def initialize_with_defaults
    self.class.schema.each do |name, attributes|
      if self.class <= Hash
        if attributes[:field_type] == :array
          if attributes[:default].nil?
            default_value = []
          else
            default_value = attributes[:default].clone
          end
        else
          # This sort of sucks, but we can't tell what's cloneable...
          begin
            default_value = attributes[:default] && attributes[:default].clone
          rescue
            default_value = attributes[:default]
          end
        end

        # Set default value for field
        self[name] = default_value
      end
    end
  end
end

require 'butterfli/data/schema/identifiable'
require 'butterfli/data/schema/authorable'
require 'butterfli/data/schema/taggable'
require 'butterfli/data/schema/likeable'
require 'butterfli/data/schema/commentable'
require 'butterfli/data/schema/shareable' 
require 'butterfli/data/schema/attributable'
require 'butterfli/data/schema/describable'
require 'butterfli/data/schema/imageable'
require 'butterfli/data/schema/mappable'