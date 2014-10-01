require 'spec_helper'

describe OData::Model do
  let(:subject) { Product[0] }

  describe 'associated_with' do
    context 'for zero to one associations' do
      it { expect(subject.supplier).to be_a(Supplier) }
    end

    context 'for one association' do

    end

    context 'for many associations' do
      it { expect(subject.categories).to be_a(Enumerable) }
      it { expect(subject.categories.first).to be_a(Category) }
    end
  end
end