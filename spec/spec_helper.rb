require 'rubygems'
require 'bundler/setup'

if ENV['CI']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
else
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'odata/model'

# Suppressing a deprecation warning
I18n.enforce_available_locales = false

OData::Service.open('http://services.odata.org/OData/OData.svc', name: 'ODataDemo')

require 'example_models/bare_model'
require 'example_models/odatademo_category'
require 'example_models/odatademo_supplier'
require 'example_models/odatademo_product'
require 'example_models/odatademo_limited_product'
require 'example_models/odatademo_person'

RSpec::Matchers.define :be_boolean do
  match do |actual|
    expect(actual).to satisfy { |x| x == true || x == false }
  end
end

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 3
  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
