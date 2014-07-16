module OData
  class Query
    # Provides a OData::Model aware means of building up queries using chained
    # methods. Also implements the Enumerable module to support working with
    # the results of any query in a sane way.
    class Builder
      include Enumerable

      SUPPORTED_OPERATIONS = [:eq, :ne, :gt, :ge, :lt, :le, :not]

      # Sets up a new Query Builder.
      # @param model [OData::Model] the model to build the query for
      def initialize(model)
        @entity_set = model.odata_entity_set
        @property_map = model.property_map
      end

      def each
        # TODO implement
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
        query_structure[:filter] << [{
          property:   lookup_property_name(value),
          opeartion:  nil,
          argument:   nil
        }]
        self
      end

      # Returns the current query structure as a valid query string.
      def to_s
        # TODO validate the actual query structure

        query_array = []
        query_array << filters_to_query
        query_array << orderby_to_query
        query_array << select_to_query
        query_array << top_to_query
        query_array << skip_to_query
        query_array.compact!

        query_string = query_array.join('&')
        "#{entity_set.name}?#{query_string}"
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

      def skip_to_query
        return nil if query_structure[:skip].nil?
        "$skip=#{query_structure[:skip]}"
      end

      def top_to_query
        return nil if query_structure[:top].nil?
        "$top=#{query_structure[:top]}"
      end

      def orderby_to_query
        return nil if query_structure[:orderby].empty?
        "$orderby=#{query_structure[:orderby].join(',')}"
      end

      def select_to_query
        return nil if query_structure[:select].empty?
        "$select=#{query_structure[:select].join(',')}"
      end

      def filters_to_query
        str = "$filter="
        clauses = []
        query_structure[:filter].each do |clause|
          clause_filters = []
          clause.each do |filter|
            clause_filters << "#{filter[:property]} #{filter[:operation]} #{filter[:argument]}"
          end
          clauses << clause_filters.join(' and ')
        end
        clauses.collect! {|clause| "(#{clause})"}
        str << clauses.join(' or ')
        str
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
        @property_map[mapping.to_s.to_sym]
      end
    end
  end
end