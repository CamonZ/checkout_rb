require 'bundler'

Bundler.require(:default, :test)

Dir['./lib/**/*.rb'].each { |f| require f }
Dir['./spec/support/**/*.rb'].each { |f| require f }

config = YAML::load(File.open('config/database.yml'))['default']
ActiveRecord::Base.establish_connection(config)

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end
