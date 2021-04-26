# frozen_string_literal: true

json.extract! app_instance, :id, :app_id, :user_id, :parameters, :public_key, :created_at, :updated_at
json.url app_instance_url(app_instance, format: :json)
