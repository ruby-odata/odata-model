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

    # Returns an array of registered attributes.
    # @return [Array]
    # @api private
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
        odata_config[:service] = OData::ServiceRegistry[service_key.to_s]
      end

      def use_entity_set(set_name)
        odata_config[:entity_set_name] = set_name.to_s
      end

      # Get the OData::Service
      # @return [OData::Service]
      # @api private
      def odata_service
        odata_config[:service]
      end

      # Get the OData::Service's namespace
      # @return [String] OData Service's namespace
      # @api private
      def odata_namespace
        odata_service.try(:namespace)
      end

      # Returns the configuration for working with the OData gem.
      # @return [Hash]
      # @api private
      def odata_config
        if class_variable_defined?(:@@odata_config)
          class_variable_get(:@@odata_config)
        else
          class_variable_set(:@@odata_config, {})
          class_variable_get(:@@odata_config)
        end
      end

      # Returns the entity set name this model is related to.
      # @return [String]
      # @api private
      def odata_entity_set_name
        odata_config[:entity_set_name] ||= self.name.pluralize
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
