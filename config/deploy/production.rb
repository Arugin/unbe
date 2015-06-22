server '54.84.121.120', user: 'ec2-user', roles: %w{app web}

set :ssh_options, {
    forward_agent: false,
    auth_methods: ["publickey"],
    keys: [ENV['AWS_SECRET_KEY_PATH']]
}