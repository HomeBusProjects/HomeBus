# frozen_string_literal: true

json.array! @app_instances, partial: 'app_instances/app_instance', as: :app_instance
