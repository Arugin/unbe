server '52.87.254.70', user: 'centos', roles: %w{app web}

set :ssh_options, {
    forward_agent: false,
    auth_methods: ["publickey"],
    keys: [ENV['AWS_SECRET_KEY_PATH']]
}