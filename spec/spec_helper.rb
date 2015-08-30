require 'coveralls'
Coveralls.wear!('rails')
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"
  config.include Devise::TestHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, {:except => %w[roles]}
  end
  config.before(:each) do
    DatabaseCleaner.start
    load "#{Rails.root}/db/test_seeds.rb"
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
