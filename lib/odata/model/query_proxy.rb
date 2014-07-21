module OData
  module Model
    # Provides the proxy between OData::Query and OData::Model.
    class QueryProxy
      attr_reader :last_criteria

      # Instantiates a new QueryProxy for the supplied OData::Model class.
      # @param model_class [Class]
      # @api private
      def initialize(model_class)
        @target = model_class
        @query = target.odata_entity_set.query
        @last_criteria = nil
      end

      # Sets up a new criteria for filters for the given property name.
      # @param property_name [Symbol]
      # @return [self]
      # @api private
      def where(property_name)
        @last_criteria = query[target.property_map[property_name]]
        self
      end

      # Sets up last criteria with supplied argument sets.
      # @param arguments [Hash]
      # @return [self]
      def is(arguments)
        raise ArgumentError 'can only accept Hash argument' unless arguments.is_a?(Hash)
        property_name = last_criteria.property
        arguments.each do |operator, value|
          @last_criteria = query[property_name].send(operator.to_sym, value)
          query.where(@last_criteria)
        end
        self
      end

      # Specifies the limit for the query.
      # @param value [to_i]
      # @return [self]
      def limit(value)
        query.limit(value.to_i)
        self
      end

      # Specifies the number of entities to skip for the query.
      # @param value [to_i]
      # @return [self]
      def skip(value)
        query.skip(value.to_i)
        self
      end

      private

      attr_reader :target, :query
    end
  end
end