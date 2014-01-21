#encoding: utf-8
source 'https://rubygems.org'

if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

ruby '1.9.3'
gem 'rails', '3.2.13'


# Bundle edge Rails instead:
gem 'bson_ext'
gem 'mongoid'
gem 'mongoid_search'
gem 'rake', '>= 10.0'
gem 'haml', '<= 3.9.9'
gem 'thin', '>= 1.5.0', group: :development
gem 'passenger', group: :production
gem 'cancan', '>= 1.6.8'
gem 'bcrypt-ruby', '3.0.1'
gem 'devise', '>= 2.1.2'
gem 'rolify', '>= 3.2.0'
gem "heroku"
gem "mongoid-paperclip", require: "mongoid_paperclip"
gem 'aws-sdk', '~> 1.3.4'
gem 'rails_12factor'
gem 'mongoid_rails_migrations', '>= 1.0.0'
gem 'voteable_mongo', git: 'https://github.com/dementrock/voteable_mongo.git'
gem 'russian', '~> 0.6.0'
gem 'impressionist'
gem 'meta-tags', require: 'meta_tags'
gem 'mongoid_slug'
gem 'nokogiri'
gem 'clockwork'
gem 'active_link_to'
gem 'merit', git: 'https://github.com/tute/merit'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

# UI gems
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '>= 2.3'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-mongoid'
gem 'client_side_validations-simple_form'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'fotoramajs'
gem 'select2-rails'
gem 'tinymce-rails', git: 'https://github.com/spohlenz/tinymce-rails', branch: 'tinymce-4'
gem 'tinymce-rails-langs'

### development and test
gem "haml-rails", ">= 0.3.5", group: :development
gem "rspec-rails", ">= 2.11.4", group: [:development, :test]
gem "capybara", ">= 1.1.2", group: :test
gem "factory_girl_rails", ">= 4.1.0", group: [:development, :test]
gem "database_cleaner", ">= 0.9.1", group: :test
gem 'coveralls', require: false