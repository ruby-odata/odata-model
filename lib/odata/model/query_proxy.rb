module OData
  module Model
    class QueryProxy
      def initialize(model_class)
        target = model_class
      end

      def where(property_name)
        self
      end

      private

      attr_accessor :target
    end
  end
end