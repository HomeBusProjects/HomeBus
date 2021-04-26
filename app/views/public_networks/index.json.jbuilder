# frozen_string_literal: true

json.array! @public_networks, partial: 'public_networks/public_network', as: :public_network
