require 'dotenv'
Dotenv.load
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/eye'
require 'capistrano/rails'
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'whenever/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
