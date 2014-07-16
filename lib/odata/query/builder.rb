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

      # Set the options for ordering the final query.
      # @param args [Symbol,Hash]
      # @return [self]
      def order_by(*args)
        validate_order_by_arguments(args)
        query_structure[:orderby] += process_order_by_arguments(args)
        self
      end

      # Set the properties to select with the final query.
      # @param args [Array<Symbol>]
      # @return self
      def select(*args)
        args.each {|arg| query_structure[:select] << arg.to_sym}
        self
      end

      private

      def query_structure
        @query_structure ||= {
            top:      nil,
            skip:     nil,
            orderby:  [],
            select:   []
        }
      end

      def entity_set
        @entity_set
      end

      def validate_order_by_arguments(args)
        args.each do |arg|
          unless arg.is_a?(Hash) || arg.is_a?(Symbol)
            raise ArgumentError, 'must be a Hash or Symbol'
          end
        end
      end

      def process_order_by_arguments(args)
        args.collect do |arg|
          case arg
            when is_a?(Symbol)
              lookup_property_name(arg)
            when is_a?(Hash)
              arg.each do |key, value|
                "#{lookup_property_name(key)} #{value}"
              end
          end
        end
      end

      def lookup_property_name(mapping)
        # TODO actually lookup the property name
        mapping.to_s
      end
    end
  end
end