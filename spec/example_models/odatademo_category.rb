class Category
  include OData::Model

  use_service 'ODataDemo'
  for_entity  'Category'
end