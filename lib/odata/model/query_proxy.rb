module OData
  module Model
    # Provides the proxy between OData::Query and OData::Model.
    class QueryProxy
      include Enumerable

      # Last filter criteria set on the query.
      attr_reader :last_criteria

      # Instantiates a new QueryProxy for the supplied OData::Model class.
      # @param model_class [Class]
      # @api private
      def initialize(model_class)
        @target = model_class
        @query = target.odata_entity_set.query
        @last_criteria = nil
        set_default_select
      end

      # Sets up a new criteria for filters for the given property name.
      # @param argument [Hash,to_sym]
      # @return [self]
      # @api private
      def where(argument)
        if argument.is_a?(Hash)
          argument.each do |property_name, value|
            self.where(property_name).is(eq: value)
          end
        else
          if argument.is_a?(String)
            @last_criteria = query[argument]
          else
            @last_criteria = query[target.property_map[argument.to_sym]]
          end
        end

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

      # Specified the ordering for the query.
      # @param property_name [to_sym]
      # @return [self]
      def order_by(property_name)
        query.order_by(target.property_map[property_name.to_sym])
        self
      end

      # Selects specific properties to return with query.
      # @param property_name [to_sym]
      # @return [self]
      def select(property_name)
        query.select(target.property_map[property_name.to_sym])
        self
      end

      # Executes the query and returns each instance of the target model in
      # turn.
      def each(&block)
        query.execute.each do |entity|
          model = target.new
          model.instance_variable_set(:@odata_entity, entity)
          block_given? ? block.call(model) : yield(model)
        end
      end

      # By default we only select the properties defined on the Model.
      # @api private
      def set_default_select
        if target.odata_config[:limit_default_selection]
          query.select(target.property_map.values)
        end
        self
      end

      private

      attr_reader :target, :query

    end
  end
end