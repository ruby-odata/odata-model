class Product
  include OData::Model

  use_service 'ODataDemo'

  property 'ID'
  property 'Name'
  property 'Description'
  property 'Rating'
  property 'Price'
  property 'ReleaseDate'
  property 'DiscontinuedDate'
end