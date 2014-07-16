require 'spec_helper'

describe OData::Query::Builder do
  let(:subject) { OData::Query::Builder.new(Product.odata_entity_set) }

  describe '#select' do
    it { expect(subject).to respond_to(:select) }

    it { expect(subject.select(:name, :description)).to be_a(OData::Query::Builder) }
    it { expect(subject.select(:name, :description)).to eq(subject) }
  end
end