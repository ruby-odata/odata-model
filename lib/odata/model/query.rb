module OData
  module Model
    # Provides the methods that make up the query interface for OData::Model.
    module Query
      extend ActiveSupport::Concern

      included do
        # ...
      end

      # Methods mixed in at the class level.
      module ClassMethods
        # Starts a query chain with a filter for a given property's name.
        # @param property_name [to_sym]
        # @return [OData::Model::Query]
        def where(property_name)
          query_proxy = OData::Model::QueryProxy.new(self)
          query_proxy.where(property_name.to_sym)
        end

        # Starts a query chain with a limit to entities returned.
        # @param value [to_i]
        # @return [OData::Model::Query]
        def limit(value)
          query_proxy = OData::Model::QueryProxy.new(self)
          query_proxy.limit(value.to_i)
        end

        # Starts a query chain with the number of entities to skip.
        # @param value [to_i]
        # @return [OData::Model::Query]
        def skip(value)
          query_proxy = OData::Model::QueryProxy.new(self)
          query_proxy.skip(value.to_i)
        end

        # Starts a query chain with a order operator for a given property's name.
        # @param property_name [to_sym]
        # @return [OData::Model::Query]
        def order_by(property_name)
          query_proxy = OData::Model::QueryProxy.new(self)
          query_proxy.order_by(property_name.to_sym)
        end

        # Enables lookup of model entities by their primary key.
        # @param primary_key_value [to_s] primary key value to lookup
        # @return [OData::Model,nil]
        def [](primary_key_value)
          entity = odata_entity_set[primary_key_value]
          model = self.new
          model.instance_variable_set(:@odata_entity, entity)
          model
        end
      end
    end
  end
end