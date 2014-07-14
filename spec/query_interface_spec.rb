require 'spec_helper'

describe OData::Model do
  describe 'query interface' do
    it { expect(Product).to respond_to(:[]) }
    it { expect(Product).to respond_to(:find) }

    describe 'Product[]' do
      it 'finds a model instance' do
        expect(Product[0]).to be_a(Product)
      end
    end

    describe 'Product.find' do
      it 'returns an OData::Query::Builder' do
        expect(Product.find).to be_a(OData::Query::Builder)
      end
    end
  end
end