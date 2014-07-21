require 'spec_helper'

describe OData::Model do
  describe 'query interface' do
    it { expect(Product).to respond_to(:[]) }
    describe 'Product[]' do
      it 'finds a model instance' do
        expect(Product[0]).to be_a(Product)
      end
    end

    it { expect(Product).to respond_to(:where) }
    describe 'Product#where' do
      it { expect(Product.where(:name)).to be_a(OData::Model::QueryProxy) }
    end
  end
end