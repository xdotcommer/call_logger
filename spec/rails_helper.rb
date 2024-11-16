# spec/rails_helper.rb
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'nulldb_rspec'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.use_active_record = false
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    NullDB.configure do |ndb|
      ndb.project_root = Rails.root
    end
    NullDB.nullify
  end

  config.before(:each, type: :request) do
    host! 'localhost'
  end

  config.after(:suite) do
    NullDB.restore
  end
end
