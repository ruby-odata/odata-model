module OData
  module Model
    module Persistence
      extend ActiveSupport::Concern

      included do
        # ...
      end

      # Returns whether the current instance has been persisted.
      # @return [Boolean]
      def persisted?
        if instance_variable_defined?(:@persisted)
          instance_variable_get(:@persisted)
        else
          instance_variable_set(:@persisted, false)
          instance_variable_get(:@persisted)
        end
      end

      # Save the current model.
      def save
        # TODO persistence work
        instance_variable_set(:@persisted, true)
        changes_applied
      end

      # Reload the model from OData
      def reload!
        # TODO reload OData entity
        reset_changes
      end

      # Methods mixed in at the class level.
      module ClassMethods
        # ...
      end
    end
  end
end