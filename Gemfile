#encoding: utf-8
source 'https://rubygems.org'

if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

ruby '2.0.0'
gem 'rails', '~> 4.0'

# Bundle edge Rails instead:
gem 'bson_ext'
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_search'
gem 'rake', '>= 10.0'
gem 'haml'
gem 'thin', '>= 1.5.0', group: :development
gem 'passenger', group: :production
gem 'cancan', '>= 1.6.8'
gem 'bcrypt-ruby', '3.0.1'
gem 'devise', '>= 2.1.2'
gem 'rolify', '>= 3.2.0'
gem "mongoid-paperclip", require: "mongoid_paperclip", git: 'https://github.com/Arugin/mongoid-paperclip', ref: '8abbab9085'
gem 'aws-sdk', '~> 1.3.4'
gem 'rails_12factor', group: :production
gem 'mongoid_rails_migrations', '>= 1.0.0'
gem 'voteable_mongo', git: 'https://github.com/Arugin/voteable_mongo'
gem 'russian', '~> 0.6.0'
gem 'impressionist'
gem 'meta-tags', require: 'meta_tags'
gem 'mongoid_slug'
gem 'nokogiri'
gem 'clockwork'
gem 'active_link_to'
gem 'merit'
gem 'state_pattern'
gem 'public_activity'


# migration
gem 'rails-observers'
gem 'coffee-rails'
gem 'uglifier', '>= 1.0.3'
gem 'elusive-icons-sass-rails'

# UI gems
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'kaminari'
gem 'simple_form'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'fotoramajs'
gem 'select2-rails'
gem 'tinymce-rails'
gem 'tinymce-rails-langs'
gem "font-awesome-rails"
gem 'omniauth'
gem 'omniauth-facebook'
gem "omniauth-twitter"
gem 'omniauth-vkontakte'
gem "omniauth-google-oauth2"
gem 'rack-cors'

### development and test
gem "haml-rails", group: :development
gem "rspec-rails", ">= 2.11.4", group: [:development, :test]
gem "capybara", ">= 1.1.2", group: :test
gem "factory_girl_rails", ">= 4.1.0", group: [:development, :test]
gem "database_cleaner", ">= 0.9.1", group: :test
gem 'coveralls', require: false