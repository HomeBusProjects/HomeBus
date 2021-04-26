# frozen_string_literal: true

json.array! @provision_requests, partial: 'provision_requests/provision_request', as: :provision_request
