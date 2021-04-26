# frozen_string_literal: true

json.extract! app, :id, :name, :source, :created_at, :updated_at
json.url app_url(app, format: :json)
