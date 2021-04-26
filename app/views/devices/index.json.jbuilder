# frozen_string_literal: true

json.array! @devices, partial: 'devices/device', as: :device
