# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'securerandom'

admin = User.create(name: 'admin', email: 'invalid-email-address', encrypted_password: SecureRandom.base64(20), site_admin: true)

broker = Broker.create(name: 'dummy-broker')

network = Network.create(name: 'prime', user: admin, broker: broker)

