require 'spec_helper'

describe OData::Model::QueryProxy do
  let(:query_proxy) { OData::Model::QueryProxy.new(Product) }
  let(:subject) { query_proxy }

  it { expect(subject).to respond_to(:where) }
  describe '#where' do
    let(:subject) { query_proxy.where(:name) }

    it { expect(subject).to be_a(OData::Model::QueryProxy) }
    it 'sets up last criteria properly' do
      expect(subject.last_criteria).to be_a(OData::Query::Criteria)
      expect(subject.last_criteria.property).to eq(Product.property_map[:name])
    end
  end

  it { expect(subject).to respond_to(:is) }
  describe '#is' do
    %w{eq ne gt lt ge le}.each do |operator|
      describe "with :#{operator} operator" do
        let(:subject) { query_proxy.where(:rating).is(operator.to_sym => 4) }

        it { expect(subject).to be_a(OData::Model::QueryProxy) }
        it 'sets up last criteria properly' do
          expect(subject.last_criteria).to be_a(OData::Query::Criteria)
          expect(subject.last_criteria.property).to eq(Product.property_map[:rating])
          expect(subject.last_criteria.operator).to eq(operator.to_sym)
          expect(subject.last_criteria.value).to eq(4)
        end
      end
    end
  end

  it { pending; expect(subject).to respond_to(:limit) }
  describe '#limit' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:skip) }
  describe '#skip' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:expand) }
  describe '#expand' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:select) }
  describe '#select' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:order_by) }
  describe '#order_by' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:and) }
  describe '#and' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:or) }
  describe '#or' do
    it { pending; fail }
  end

  it { pending; expect(subject).to respond_to(:not) }
  describe '#not' do
    it { pending; fail }
  end
end