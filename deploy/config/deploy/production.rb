# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

set :stage, :production
server "hipster.homebus.io", user: "homebus", roles: %w{web app db}
server "ctrlh.homebus.io", user: "homebus", roles: %w{web app db}, ssh_options: { port: 3456 }
