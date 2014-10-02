# CHANGELOG

## 0.6.1

* Added support for declaring association class_name as a string.

## 0.6.0

* Updated to work with OData gem version 0.6.0
* Integrated support for OData gem's support for associations

## 0.5.x

* Lots of changes

## 0.4.1

* Added validation a property exists for an Entity when setting up its mapping.

## 0.4.0

* Removed strict dependency on ActiveModel.
* Added `limit_default_selection` setting to limit default queries to only the
  supplied properties of a model.

## 0.3.0

* Added OData::Model::Railtie for Ruby on Rails integration.

## 0.2.0

* Added `odata_service_name` to private API methods
* Added `for_entity` as alternative to `use_entity_set`

## 0.1.1

* Added bin/odata-model
  * `list` command lists available EntitySets and their type
  * `generate` command generates a boilerplate model class

## 0.1.0

* Basic model behavior via property mapping and query interface.