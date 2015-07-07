require 'dotenv'
Dotenv.load
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'whenever/capistrano'
require 'capistrano/passenger'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
