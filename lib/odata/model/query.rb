module OData
  module Model
    module Query
      extend ActiveSupport::Concern

      included do
        # ...
      end

      # Methods mixed in at the class level.
      module ClassMethods
        # Starts a chain for building up an OData query.
        # @return [OData::Query::Builder]
        def find
          OData::Query::Builder.new(self)
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