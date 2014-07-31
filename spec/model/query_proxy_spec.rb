require 'spec_helper'

describe OData::Model::QueryProxy do
  let(:subject) { query_proxy }
  let(:query_proxy) { OData::Model::QueryProxy.new(Product) }
  let(:query_string) { subject.send(:query).to_s }

  it 'allows limiting default selection to only selecting defined properties' do
    query_proxy = OData::Model::QueryProxy.new(LimitedProduct)
    query_string = query_proxy.send(:query).to_s
    expect(query_string).to eq('Products?$select=ID,Name,Rating,Price')
  end

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

        it 'properly generates query' do
          expect(query_string).to eq("Products?$filter=Rating #{operator} 4")
        end
      end
    end
  end

  it { expect(subject).to respond_to(:limit) }
  describe '#limit' do
    let(:subject) { query_proxy.limit(3) }

    it { expect(subject).to be_a(OData::Model::QueryProxy) }

    it 'properly generates query' do
      expect(query_string).to eq('Products?$top=3')
    end
  end

  it { expect(subject).to respond_to(:skip) }
  describe '#skip' do
    let(:subject) { query_proxy.skip(6) }

    it { expect(subject).to be_a(OData::Model::QueryProxy) }

    it 'properly generates query' do
      expect(query_string).to eq('Products?$skip=6')
    end
  end

  it { pending; expect(subject).to respond_to(:expand) }
  describe '#expand' do
    it { pending; fail }
  end

  it { expect(subject).to respond_to(:select) }
  describe '#select' do
    let(:subject) { query_proxy.select(:name) }

    it { expect(subject).to be_a(OData::Model::QueryProxy) }

    it 'properly generates query' do
      expect(query_string).to eq('Products?$select=Name')
    end
  end

  it { expect(subject).to respond_to(:order_by) }
  describe '#order_by' do
    let(:subject) { query_proxy.order_by(:rating) }

    it { expect(subject).to be_a(OData::Model::QueryProxy) }

    it 'properly generates query' do
      expect(query_string).to eq('Products?$orderby=Rating')
    end
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

  it { expect(subject).to respond_to(:each) }
  describe '#each' do
    it 'returns model instances in turn' do
      counter = 0
      subject.each do |model|
        expect(model).to be_a(Product)
        counter += 1
      end
      expect(counter).to eq(11)
    end
  end
end