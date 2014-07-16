require 'spec_helper'

describe OData::Query::Builder do
  let(:subject) { OData::Query::Builder.new(Product) }

  describe '#to_s' do
    it 'properly builds queries' do
      query_string = "Products?$filter=(Name eq 'Bread')"
      query = subject.where(:name).is(eq: "'Bread'")
      expect(query.to_s).to eq(query_string)
    end

    it 'properly builds queries' do
      query_string = "Products?$filter=(Name eq 'Bread') or (Name eq 'Milk')"
      query = subject.where(:name).is(eq: "'Bread'").or(:name).is(eq: "'Milk'")
      expect(query.to_s).to eq(query_string)
    end

    it 'properly builds queries' do
      query_string = 'Products?$filter=(Price lt 15 and Rating gt 3)'
      query = subject.where(:price).is(lt: 15).and(:rating).is(gt: 3)
      expect(query.to_s).to eq(query_string)
    end
  end
end