module OData
  module Model
    # The OData::Model::Configuration module encapsulates all the functionality
    # specifically needed for OData::Model to maintain internal configuration
    # details about it's relationship to the OData gem.
    module Configuration
      extend ActiveSupport::Concern

      included do
        # ...
      end

      # Returns the entity the current model is associated with, or a fresh
      # entity.
      # @return [OData::Entity]
      # @api private
      def odata_entity
        @odata_entity ||= self.class.odata_service[odata_entity_set_name].new_entity
      end

      # Returns the name of the OData::EntitySet the current model is related
      # to.
      # @return [String]
      # @api private
      def odata_entity_set_name
        self.class.odata_entity_set_name
      end

      # Returns the OData::EntitySet the current model is related to.
      # @return [OData::EntitySet]
      # @api private
      def odata_entity_set
        self.class.odata_entity_set
      end

      # Methods mixed in at the class level.
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
          nil
        end

        # Define the entity set to use for the current OData::Model. This
        # method will record in the OData configuration the supplied name so
        # that it can be used to communicate properly with the underlying
        # OData::Service.
        #
        # @param set_name [to_s] name of EntitySet used by OData service
        # @return [nil]
        def use_entity_set(set_name)
          odata_config[:entity_set_name] = set_name.to_s
          nil
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

        # Returns the OData::EntitySet the current model is related to.
        # @return [OData::EntitySet]
        # @api private
        def odata_entity_set
          odata_config[:entity_set] ||= odata_service[odata_entity_set_name]
        end
      end
    end
  end
end