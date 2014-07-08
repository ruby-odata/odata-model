require 'active_model'
require 'active_support/core_ext'
require 'active_support/concern'

require 'odata'
require 'odata/model/version'
require 'odata/model/configuration'
require 'odata/model/attributes'

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
    include OData::Model::Attributes

    included do
      # ...
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
