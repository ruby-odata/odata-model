require 'active_model'
require 'active_support/core_ext'
require 'active_support/concern'

require 'odata'
require 'odata/model/version'
require 'odata/model/configuration'

# OData is the parent namespace for the OData::Model project.
module OData
  # OData::Model provides a way to map from OData::Entity instances, as
  # returned by the OData gem, to Ruby objects that will work with Rails via
  # the ActiveModel semantics.
  module Model
    extend ActiveSupport::Concern

    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion

    include OData::Model::Configuration

    included do
      # ...
    end

    # Returns an array of registered attributes.
    # @return [Array]
    # @api private
    def attributes
      self.class.class_variable_get(:@@attributes)
    end


    # Integrates ActiveModel's error handling capabilities
    # @return [ActiveModel::Errors]
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    # Returns whether the current instance has been persisted.
    # @return [Boolean]
    def persisted?
      false
    end

    # Used for ActiveModel validations
    # @api private
    def read_attribute_for_validation(attr)
      send(attr)
    end

    # Methods integrated at the class level when OData::Model is included into
    # a given class.
    module ClassMethods
      # Defines a property from this model's related OData::Entity you want
      # mapped to an attribute.
      #
      # @param literal_name [to_s] the literal Entity property name
      # @param options [Hash] hash of options
      # @return nil
      def property(literal_name, options = {})
        register_attribute(literal_name, options)
        create_accessors(literal_name, options)
        nil
      end

      # Returns an array of all registered attributes
      # @return [Array]
      # @api private
      def attributes
        if self.class_variable_defined?(:@@attributes)
          class_variable_get(:@@attributes)
        else
          class_variable_set(:@@attributes, [])
          class_variable_get(:@@attributes)
        end
      end

      # Used for ActiveModel validations
      # @api private
      def human_attribute_name(attr, options = {})
        attr
      end

      # Used for ActiveModel validations
      # @api private
      def lookup_ancestors
        [self]
      end

      private

      def register_attribute(literal_name, options)
        attributes << (options[:as].try(:to_sym) || literal_name.to_s.underscore.to_sym)
      end

      def create_accessors(literal_name, options)
        class_eval do
          attr_accessor (options[:as] || literal_name.to_s.underscore).to_sym
        end
      end
    end
  end
end
