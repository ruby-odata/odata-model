require 'spec_helper'

describe OData::Model do
  describe 'EntitySet identification and configuration' do
    describe 'default behavior' do
      it { expect(Product.odata_entity_set_name).to eq('Products') }
    end

    describe 'using for_entity' do
      it { expect(Person.odata_entity_set_name).to eq('Persons') }
    end
  end
end