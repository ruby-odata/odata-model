require 'odata'
require 'odata/model/version'

require 'active_model'
require 'active_support/core_ext'
require 'active_support/concern'

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

    included do
      # ...
    end

    def attributes
      self.class.class_variable_get(:@@attributes)
    end

    def odata_entity
      @odata_entity ||= self.class.odata_service[odata_entity_set_name].new_entity
    end

    def odata_entity_set_name
      self.class.odata_entity_set_name
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
      # Define the service to use for the current OData::Model. This method
      # will cause the service to be looked up in the OData::ServiceRegistry
      # by the supplied key, so it can accept either the service's URL or its
      # namespace.
      #
      # @param service_key [to_s] service URL or namespace
      # @return [nil]
      def use_service(service_key)
        self.class_eval <<-EOS
          @@odata_service = OData::ServiceRegistry['#{service_key}']
        EOS
        nil
      end

      # Get the OData::Service
      # @return [OData::Service]
      # @api private
      def odata_service
        self.class_eval <<-EOS
          @@odata_service
        EOS
      end

      # Get the OData::Service's namespace
      # @return [String] OData Service's namespace
      # @api private
      def odata_namespace
        self.class_eval <<-EOS
          @@odata_service.nil? ? nil : @@odata_service.namespace
        EOS
      end

      def odata_entity_set_name
        self.class_eval <<-EOS
          @@odata_entity_set_name ||= self.name.pluralize
        EOS
      end

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

      def register_attribute(literal_name, options)
        attribute_to_register = options[:as].try(:to_sym) || literal_name.to_s.underscore.to_sym

        if self.class_variable_defined?(:@@attributes)
          attributes = class_variable_get(:@@attributes)
          attributes << attribute_to_register
          class_variable_set(:@@attributes, attributes)
        else
          class_variable_set(:@@attributes, [attribute_to_register])
        end
      end

      def create_accessors(literal_name, options)
        class_eval do
          attr_accessor (options[:as] || literal_name.to_s.underscore).to_sym
        end
      end

      def attributes
        class_variable_get(:@@attributes)
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
    end
  end
end
