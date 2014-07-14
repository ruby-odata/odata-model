require 'spec_helper'

describe OData::Model do
  describe 'service integration' do
    let(:service) { OData::ServiceRegistry['ODataDemo'] }

    it { expect(Product).to respond_to(:odata_service) }
    it { expect(Product.odata_service).to be_a(OData::Service) }
    it { expect(Product.odata_service).to eq(service)}

    it { expect(Product).to respond_to(:odata_namespace) }
    it { expect(Product.odata_namespace).to eq('ODataDemo') }
  end
end