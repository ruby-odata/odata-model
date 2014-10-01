class Supplier
  include OData::Model

  use_service 'ODataDemo'
  for_entity  'Supplier'
end