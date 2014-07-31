require 'active_model'
require 'spec_helper'

describe OData::Model do
  let(:subject) { Product.new }

  it { expect(Product).to respond_to(:model_name) }

  it { expect(subject).to respond_to(:to_key) }
  it { expect(subject).to respond_to(:to_param) }
  it { expect(subject).to respond_to(:to_partial_path) }
  it { expect(subject).to respond_to(:persisted?) }
  it { expect(subject).to respond_to(:to_model) }
  it { expect(subject).to respond_to(:errors) }

  describe '#to_key' do
    it 'returns nil when #persisted? is false' do
      def subject.persisted?() false end

      expect(subject.to_key).to be_nil
    end
  end

  describe '#to_param' do
    it 'returns nil when #persisted? is false' do
      def subject.to_key() [1] end
      def subject.persisted?() false end

      expect(subject.to_param).to be_nil
    end
  end

  describe '#to_partial_path' do
    it 'returns a String' do
      expect(subject.to_partial_path).to be_a_kind_of(String)
    end
  end

  describe '#persisted?' do
    it 'returns a boolean' do
      expect(subject.persisted?).to be_boolean
    end
  end

  describe '.model_name' do
    let(:model_name) { Product.model_name }

    it { expect(model_name).to respond_to(:to_str) }
    it { expect(model_name.human).to respond_to(:to_str) }
    it { expect(model_name.singular).to respond_to(:to_str) }
    it { expect(model_name.plural).to respond_to(:to_str) }
  end

  describe '#errors[]' do
    it 'returns an Array' do
      expect(subject.errors[:hello]).to be_a(Array)
    end
  end
end