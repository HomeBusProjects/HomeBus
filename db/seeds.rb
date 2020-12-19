# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'securerandom'

admin = User.create(name: 'admin', email: 'invalid-email-address@localhost', password: SecureRandom.base64(20), site_admin: true)

# development environment has a broker in Docker
if Rails.env == 'development'
  broker = Broker.create(name: 'homebus-mosquitto')
end

if Rails.env == 'staging'
  broker = Broker.create(name: 'mqtt-staging.homebus.io')
end

if Rails.env == 'production'
  broker = Broker.create(name: 'mqtt0.homebus.io')
end

network = Network.create(name: 'prime', broker: broker)
network.users << admin

