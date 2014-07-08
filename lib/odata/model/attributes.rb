module OData
  module Model
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
end