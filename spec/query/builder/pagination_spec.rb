require 'spec_helper'

describe OData::Query::Builder do
  let(:subject) { OData::Query::Builder.new(Product) }

  describe 'pagination method' do
    describe '#skip' do
      it { expect(subject).to respond_to(:skip) }
      it { expect(subject.skip(5)).to be_a(OData::Query::Builder) }
      it { expect(subject.skip(5)).to eq(subject) }
    end

    describe '#limit' do
      it { expect(subject).to respond_to(:limit) }
      it { expect(subject.limit(5)).to be_a(OData::Query::Builder) }
      it { expect(subject.limit(5)).to eq(subject) }
    end
  end
end