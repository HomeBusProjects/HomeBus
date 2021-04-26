# frozen_string_literal: true

json.extract! mosquitto_account, :id, :username, :password, :superuser, :provision_request_id, :created_at, :updated_at
json.url mosquitto_account_url(mosquitto_account, format: :json)
