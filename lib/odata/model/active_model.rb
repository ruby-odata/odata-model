require 'active_model'

module OData
  module Model
    # The OData::Model::ActiveModel module encapsulates all the functionality
    # specifically needed for OData::Model to work with Rails via the
    # ActiveModel conventions.
    module ActiveModel
      extend ActiveSupport::Concern

      extend ::ActiveModel::Naming
      include ::ActiveModel::Validations
      include ::ActiveModel::Conversion
      include ::ActiveModel::Dirty

      included do
        # ...
      end

      # Integrates ActiveModel's error handling capabilities
      # @return [ActiveModel::Errors]
      def errors
        @errors ||= ::ActiveModel::Errors.new(self)
      end

      # Used for ActiveModel validations
      # @api private
      def read_attribute_for_validation(attr)
        send(attr)
      end

      # Methods mixed in at the class level.
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