require 'spec_helper'

describe OData::Model::QueryProxy do
  let(:subject) { OData::Model::QueryProxy.new(Product) }

  it { expect(subject).to respond_to(:where) }
  describe '#where' do
    it { pending; fail }
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