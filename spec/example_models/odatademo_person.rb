class Person
  include OData::Model

  use_service 'ODataDemo'
  for_entity 'Person'

  property 'ID'
  property 'Name'
end