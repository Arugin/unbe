#encoding: utf-8
source 'https://rubygems.org'

if RUBY_VERSION =~ /1.9/ # assuming you're running Ruby ~1.9
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

ruby '1.9.3'
gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'bson_ext'
gem 'mongoid'
gem 'mongoid_search'
gem 'rake', '>= 10.0'
gem 'haml', '<= 3.9.9'
gem 'thin', '>= 1.5.0'
gem 'cancan', '>= 1.6.8'
gem 'bcrypt-ruby', '3.0.1'
gem 'devise', '>= 2.1.2'
gem "heroku"


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '>= 2.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

# UI gems
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-mongoid'
gem 'client_side_validations-simple_form'
gem 'jquery-datatables-rails'



### development and test
gem "haml-rails", ">= 0.3.5", :group => :development