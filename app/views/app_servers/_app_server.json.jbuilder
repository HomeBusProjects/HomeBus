# frozen_string_literal: true

json.extract! app_server, :id, :name, :port, :secret_key, :created_at, :updated_at
json.url app_server_url(app_server, format: :json)
