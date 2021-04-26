# frozen_string_literal: true

json.array! @permissions, partial: 'permissions/permission', as: :permission
