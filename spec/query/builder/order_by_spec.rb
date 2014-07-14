require 'spec_helper'

describe OData::Query::Builder do
  let(:subject) { OData::Query::Builder.new(Product.odata_entity_set) }

  describe '#order_by' do
    it { expect(subject).to respond_to(:order_by) }

    describe 'accepts Symbols' do
      it { expect(subject.order_by(:name)).to be_a(OData::Query::Builder) }
      it { expect(subject.order_by(:name)).to eq(subject) }

      it { expect(subject.order_by(:price, :rating)).to be_a(OData::Query::Builder) }
      it { expect(subject.order_by(:price, :rating)).to eq(subject) }
    end

    describe 'accepts a Hash' do
      it { expect(subject.order_by(name: :asc)).to be_a(OData::Query::Builder) }
      it { expect(subject.order_by(name: :asc)).to eq(subject) }
    end
  end
end