# frozen_string_literal: true

json.extract! provision_request, :id, :pin, :ip_adress, :wo_topics, :ro_topics, :status, :created_at, :updated_at
json.url provision_request_url(provision_request, format: :json)
