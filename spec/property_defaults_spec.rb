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
  end
end