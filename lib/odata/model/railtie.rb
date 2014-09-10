module OData
  module Model
    # Defines the necessary hooks to work correctly with Ruby on Rails.
    # @api private
    class Railtie < ::Rails::Railtie
      attr_accessor :configuration

      initializer('odata.load-config') do
        config_file = Rails.root.join('config', 'odata.yml').read

        parsed_config = YAML.load(config_file)
        self.configuration = parsed_config.with_indifferent_access

        configuration[Rails.env].each do |service_name, service_details|
          url = service_details[:url]
          options = generate_options(service_name, service_details)
          OData::Service.open(url, options)
          validate_service_setup(service_name)
        end
      end

      private

      def generate_options(service_name, service_details)
        options = { name: service_name }
        if service_details[:username] && service_details[:password]
          options[:typhoeus] = {
              username: service_details[:username],
              password: service_details[:password]
          }
          options[:typhoeus][:auth_method] = service_details[:auth_type].to_sym
        end
        options
      end

      def validate_service_setup(service_name)
        service = OData::ServiceRegistry[service_name]
        service.namespace
      rescue StandardError
        raise RuntimeError, "could not access service at #{service.service_url}"
      end
    end
  end
end
