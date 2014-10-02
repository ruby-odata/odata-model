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

  associated_with 'Categories', class_name: Category, as: :categories
  associated_with 'Supplier', class_name: 'Supplier', as: :supplier
end