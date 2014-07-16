require 'spec_helper'

describe OData::Query::Builder do
  let(:subject) { OData::Query::Builder.new(Product.odata_entity_set) }

  describe 'filter method' do
    describe '#where' do
      it { expect(subject).to respond_to(:where) }

      it { expect(subject.where(:name)).to be_a(OData::Query::Builder) }
      it { expect(subject.where(:name)).to eq(subject) }
    end

    describe '#is' do
      let(:subject) { OData::Query::Builder.new(Product.odata_entity_set).where(:name) }

      it { expect(subject).to respond_to(:is) }

      it { expect(subject.is(eq: 'Bread')).to be_a(OData::Query::Builder) }
      it { expect(subject.is(eq: 'Bread')).to eq(subject) }
    end

    describe '#and' do
      let(:subject) { OData::Query::Builder.new(Product.odata_entity_set).where(:name).is(eq: 'Bread') }

      it { expect(subject).to respond_to(:and) }

      it { expect(subject.and(:name)).to be_a(OData::Query::Builder) }
      it { expect(subject.and(:name)).to eq(subject) }
    end

    describe '#or' do
      let(:subject) { OData::Query::Builder.new(Product.odata_entity_set).where(:name).is(eq: 'Bread') }

      it { expect(subject).to respond_to(:or) }

      it { expect(subject.or(:name)).to be_a(OData::Query::Builder) }
      it { expect(subject.or(:name)).to eq(subject) }
    end
  end
end