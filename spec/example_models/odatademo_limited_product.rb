class LimitedProduct
  include OData::Model

  use_service 'ODataDemo'
  for_entity  'Product'

  limit_default_selection

  property 'ID'
  property 'Name'
  property 'Rating'
  property 'Price'
end