module OData
  module Model
    # Provides the proxy between OData::Query and OData::Model.
    # @api private
    class QueryProxy
      # Instantiates a new QueryProxy for the supplied OData::Model class.
      # @param model_class [Class]
      def initialize(model_class)
        target = model_class
      end

      # Sets up a new criteria for filters for the given property name.
      # @param property_name [Symbol]
      def where(property_name)
        self
      end

      private

      attr_accessor :target
    end
  end
end