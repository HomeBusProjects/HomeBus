# frozen_string_literal: true

json.extract! device, :id, :provisioned, :friendly_name, :manufacturer, :model_number, :serial_number, :accuracy,
              :precision, :update_frequency, :bridge, :provision_request_id, :created_at, :updated_at
json.url device_url(device, format: :json)
