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

    it { expect(Product).to respond_to(:limit) }
    describe 'Product#limit' do
      it { expect(Product.limit(3)).to be_a(OData::Model::QueryProxy) }
    end

    it { expect(Product).to respond_to(:skip) }
    describe 'Product#skip' do
      it { expect(Product.skip(6)).to be_a(OData::Model::QueryProxy) }
    end

    it { expect(Product).to respond_to(:order_by) }
    describe 'Product#order_by' do
      it { expect(Product.order_by(:rating)).to be_a(OData::Model::QueryProxy) }
    end

    it { expect(Product).to respond_to(:select) }
    describe 'Product#order_by' do
      it { expect(Product.select(:name)).to be_a(OData::Model::QueryProxy) }
    end
  end
end