require 'spec_helper'

describe OData::Model do
  describe 'property defaults' do
    properties = %w{ID Name Description Rating Price ReleaseDate DiscontinuedDate}
    attributes = properties.collect {|k| k.underscore.to_sym}

    attributes.each do |attr_name|
      it { expect(Product.new).to respond_to(attr_name) }
    end

    attributes.each do |attr_name|
      it { expect(Product.new).to respond_to("#{attr_name}=") }
    end

    it { expect(Product).to respond_to(:attributes)}
    it { expect(Product.attributes).to eq(attributes) }

    it { expect(Product.new).to respond_to(:attributes) }
    it { expect(Product.new.attributes).to eq(attributes) }

    it 'raises an error if the property does not exist on the entity' do
      expect {
        class InvalidProduct
          include OData::Model

          use_service 'ODataDemo'
          for_entity 'Product'

          property 'NonExistent'
        end
      }.to raise_error(ArgumentError, 'property NonExistent does not exist for Product entity')
    end
  end
end