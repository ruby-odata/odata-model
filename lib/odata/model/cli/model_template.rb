require 'erb'

module OData
  module Model
    # Module for classes related to command-line tools
    module CLI
      # Represents the model template used by the command-line generator.
      # @api private
      class ModelTemplate
        attr_reader :class_name, :service_name, :properties

        def initialize(class_name, service_name, properties, entity_name)
          @class_name = class_name
          @service_name = service_name
          @properties = properties
          @entity_name = entity_name
        end

        def template
          <<-EOS
class <%= @class_name %>
  include OData::Model

  use_service '<%= @service_name %>'
  <%= @entity_name.nil? ? nil : "for_entity  '\#\{@entity_name\}'" %>

<% properties.each do |property_name, as_name| %>
  property '<%= property_name %>'<%= as_name.nil? ? nil : ", as: :\#\{as_name\}" %>
<% end %>
end
          EOS
        end

        def render
          renderer = ERB.new(template, 0, '<>')
          renderer.result(binding)
        end
      end
    end
  end
end