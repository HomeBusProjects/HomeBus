# frozen_string_literal: true

json.array! @public_devices, partial: 'public_devices/public_device', as: :public_device
