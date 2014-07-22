module OData
  module Model
    # Module for classes related to command-line tools
    module CLI
      # Represents the configuration for the command-line tool responsible for
      # model generation.
      # @api private
      class GeneratorConfiguration
        attr_reader :service, :options

        def initialize(options)
          @options = options
          @service = OData::Service.open(service_url, handle_auth_options)
        end

        def generate
          template = ModelTemplate.new(class_name, service_name, properties)
          template.render
        end

        def self.validate_service_url(opts)
          unless opts[:service_url]
            puts 'You must supply a service_url (-s, --service_url=)'
            exit(1)
          end
        end

        private

        def class_name
          options[:model_name] || entity_set.type
        end

        def properties
          if options[:properties]
            Hash[options[:properties].collect {|property_set| property_set.split(':')}]
          else
            properties = service.properties_for(entity_set.type)
            Hash[properties.collect {|k,v| [k, nil]}]
          end
        end

        def service_name
          options[:service_name] || service_url
        end

        def service_url
          options[:service_url]
        end

        def entity_set
          service[options[:entity_set]]
        end

        def handle_auth_options
          service_options = {}
          if options[:username] && options[:password]
            service_options[:typhoeus] = {
                username: options[:username],
                password: options[:password]
            }
            if options[:auth_type]
              auth_type = options[:auth_type].to_sym
              service_options[:typhoeus][:httpauth] = auth_type
            end
          end
          service_options
        end
      end
    end
  end
end