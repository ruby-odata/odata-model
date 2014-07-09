module OData
  module Model
    # The OData::Model::Attributes module encapsulates all the functionality
    # specifically needed for OData::Model to support the mapping of
    # OData::Entity properties to attributes on the class that includes
    # OData::Model.
    module Attributes
      extend ActiveSupport::Concern

      included do
        # ...
      end

      # Returns an array of registered attributes.
      # @return [Array]
      # @api private
      def attributes
        self.class.class_variable_get(:@@attributes)
      end

      # Returns the hash for the attribute to property mapping.
      # @return [Hash]
      # @api private
      def property_map
        self.class.class_variable_get(:@@property_map)
      end

      # Methods mixed in at the class level.
      module ClassMethods
        # Defines a property from this model's related OData::Entity you want
        # mapped to an attribute.
        #
        # @param literal_name [to_s] the literal Entity property name
        # @param options [Hash] hash of options
        # @return nil
        def property(literal_name, options = {})
          attribute_name = (options[:as] || literal_name.to_s.underscore).to_sym

          register_attribute(attribute_name, literal_name, options)
          create_accessors(attribute_name)

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

        # Returns a hash keyed to the attribute name of passed options from the
        # property definitions.
        # @return [Hash]
        # @api private
        def attribute_options
          if self.class_variable_defined?(:@@attribute_options)
            class_variable_get(:@@attribute_options)
          else
            class_variable_set(:@@attribute_options, {})
            class_variable_get(:@@attribute_options)
          end
        end

        # Returns a hash keyed to the attribute name with the values being the
        # literal OData property name to use when accessing entity data.
        # @return [Hash]
        # @api private
        def property_map
          if self.class_variable_defined?(:@@property_map)
            class_variable_get(:@@property_map)
          else
            class_variable_set(:@@property_map, {})
            class_variable_get(:@@property_map)
          end
        end

        # Registers a supplied attribute with its literal property name and any
        # provided options.
        # @return [nil]
        # @api private
        def register_attribute(attribute_name, literal_name, options)
          attributes << attribute_name
          attribute_options[attribute_name] = options
          property_map[attribute_name] = literal_name

          # Ties into ActiveModel::Dirty
          define_attribute_methods attribute_name

          nil
        end

        # Create attribute accessors for the supplied attribute name.
        # @return [nil]
        # @api private
        def create_accessors(attribute_name)
          class_eval do
            define_method(attribute_name) do
              odata_entity[property_map[attribute_name]]
            end

            define_method("#{attribute_name}=") do |value|
              unless entity[property_map[attribute_name]] == value
                send("#{attribute_name}_will_change!")
              end

              odata_entity[property_map[attribute_name]] = value
            end
          end

          nil
        end
      end
    end
  end
end