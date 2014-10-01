module OData
  module Model
    # The OData::Model::Associations module encapsulates all the functionality
    # specifically needed for OData::Model to support the mapping of
    # OData::Entity associations in a convenient way.
    module Associations
      extend ActiveSupport::Concern

      included do
        # ...
      end

      module ClassMethods
        def associated_with(association_name, options = {})
          validate_association(association_name)
          register_association(association_name, options)
          create_association_accessors(association_name)
          nil
        end

        # Returns the configuration for working with OData associations.
        # @return [Hash]
        # @api private
        def odata_associations
          if class_variable_defined?(:@@odata_associations)
            class_variable_get(:@@odata_associations)
          else
            class_variable_set(:@@odata_associations, {})
            class_variable_get(:@@odata_associations)
          end
        end

        def validate_association(association_name)
          raise ArgumentError unless odata_service.navigation_properties[odata_entity_set.type][association_name]
        end

        def register_association(association_name, options)
          odata_associations[association_name] = options
        end

        def create_association_accessors(association_name)
          accessor_name = odata_associations[association_name][:as] ||
              association_name.downcase.to_sym

          class_eval do
            define_method(accessor_name) do
              association_entities = odata_entity.associations[association_name]
              if association_entities.is_a?(Enumerable)
                association_entities.collect do |entity|
                  model = self.class.odata_associations[association_name][:class_name].new
                  model.instance_variable_set(:@odata_entity, entity)
                  model
                end
              else
                return nil if association_entities.nil?
                model = self.class.odata_associations[association_name][:class_name].new
                model.instance_variable_set(:@odata_entity, association_entities)
                model
              end
            end

            #define_method("#{attribute_name}=") do |value|
              # unless entity[property_map[attribute_name]] == value
              #   send("#{attribute_name}_will_change!") if defined?(::ActiveModel)
              # end
            #
            #  odata_entity[property_map[attribute_name]] = value
            #end
          end
        end
      end
    end
  end
end