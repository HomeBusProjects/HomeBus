# frozen_string_literal: true

json.array! @app_servers, partial: 'app_servers/app_server', as: :app_server
