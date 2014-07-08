require 'active_model'

module OData
  module Model
    module ActiveModel
      extend ActiveSupport::Concern

      extend ::ActiveModel::Naming
      include ::ActiveModel::Validations
      include ::ActiveModel::Conversion

      included do
        # ...
      end

      # Integrates ActiveModel's error handling capabilities
      # @return [ActiveModel::Errors]
      def errors
        @errors ||= ::ActiveModel::Errors.new(self)
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

      # @api private
      module ClassMethods
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
end