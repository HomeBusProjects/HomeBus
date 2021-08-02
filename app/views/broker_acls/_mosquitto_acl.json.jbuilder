# frozen_string_literal: true

json.extract! mosquitto_acl, :id, :username, :topic, :rw, :provision_request, :created_at, :updated_at
json.url mosquitto_acl_url(mosquitto_acl, format: :json)
