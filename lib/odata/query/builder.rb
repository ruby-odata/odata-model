module OData
  class Query
    class Builder
      SUPPORTED_OPERATIONS = [:eq, :ne, :gt, :ge, :lt, :le, :not]

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

      # Sets up a new filter condition on the provided property mapping.
      # @param value [to_s]
      # @return self
      def where(value)
        last_filter = query_structure[:filter].last
        clause = {
          property:   lookup_property_name(value),
          opeartion:  nil,
          argument:   nil
        }

        if last_filter.is_a?(Array)
          last_filter << clause
        else
          query_structure[:filter] << [clause]
        end
        self
      end

      # Sets the operation and argument for the last filter condition started
      # by #where, #and or #or.
      # @param value [Hash]
      # @return self
      def is(value)
        value = value.first
        validate_is_argument(value)
        last_filter = query_structure[:filter].last.last
        if last_filter[:operation].nil? && last_filter[:argument].nil?
          last_filter[:operation] = value[0].to_sym
          last_filter[:argument] = value[1]
        else
          query_structure[:filter].last << {
              property:   last_filter[:property],
              operation:  value[0].to_sym,
              argument:   value[1]
          }
        end
        self
      end

      # Adds another filter to the last supplied clause.
      # @param value [to_s]
      # @return self
      def and(value)
        query_structure[:filter].last << {
          property:   lookup_property_name(value),
          opeartion:  nil,
          argument:   nil
        }
        self
      end

      # Adds an alternate filter after the last supplied clause.
      # @param value [to_s]
      # @return self
      def or(value)
        where(value)
      end

      private

      def query_structure
        @query_structure ||= {
            top:      nil,
            skip:     nil,
            orderby:  [],
            select:   [],
            filter:   []
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

      def validate_is_argument(value)
        raise ArgumentError, 'argument must be a hash' unless value.size == 2
        raise ArgumentError, "unsupported operation: #{value[0]}" unless SUPPORTED_OPERATIONS.include?(value[0].to_sym)
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