# frozen_string_literal: true

json.array! @mosquitto_acls, partial: 'mosquitto_acls/mosquitto_acl', as: :mosquitto_acl
