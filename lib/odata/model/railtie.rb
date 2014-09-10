module OData
  module Model
    # Defines the necessary hooks to work correctly with Ruby on Rails.
    # @api private
    class Railtie < ::Rails::Railtie
      attr_accessor :configuration

      config.odata = ActiveSupport::OrderedOptions.new

      initializer('odata_configuration') do |app|
        parse_configuration(app)
        process_configuration(app)
      end

      private

      def parse_configuration(app)
        config_file = File.open(File.join(Rails.root, 'config/odata.yml')).read
        parsed_config = YAML.load(config_file)
        configuration = ActiveSupport::HashWithIndifferentAccess.new(parsed_config)
      end

      def process_configuration(app)
        configuration[Rails.env].each do |service_name, service_details|
          url = service_details[:url]
          options = generate_options(service_name, service_details)
          OData::Service.open(url, options)
          validate_service_setup(service_name)
        end
      end

      def generate_options(service_name, service_details)
        options = { name: service_name }
        if service_details[:username] && service_details[:password]
          options[:typohoeus] = {
              username: service_details[:username],
              password: service_details[:password]
          }
          options[:typhoeus][:auth_type] = service_details[:auth_type]
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
