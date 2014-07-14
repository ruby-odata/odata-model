module OData
  class Query
    class Builder
      # Sets up a new Query Builder.
      # @param entity_set [OData::EntitySet] the EntitySet to query
      def initialize(entity_set)
        @entity_set = entity_set
      end

      # Set the number of entities to skip for the final query.
      # @param value [to_i,nil]
      # @return [self]
      def skip(value)
        value = nil if value == 0
        query_structure[:skip] = value.try(:to_i)
        self
      end

      # Set the number of entities to return in the final query.
      # @param value [to_i,nil]
      # @return [self]
      def limit(value)
        value = nil if value == 0
        query_structure[:top] = value.try(:to_i)
        self
      end

      private

      def query_structure
        @query_structure ||= {
            top:   nil,
            skip:  nil
        }
      end

      def entity_set
        @entity_set
      end
    end
  end
end