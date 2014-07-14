module OData
  class Query
    class Builder
      # Sets up a new Query Builder.
      # @param entity_set [OData::EntitySet] the EntitySet to query
      def initialize(entity_set)
        @entity_set = entity_set
      end

      private

      def entity_set
        @entity_set
      end
    end
  end
end