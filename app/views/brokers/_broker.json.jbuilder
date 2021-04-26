# frozen_string_literal: true

json.extract! broker, :id, :name, :auth_token, :created_at, :updated_at
json.url broker_url(broker, format: :json)
