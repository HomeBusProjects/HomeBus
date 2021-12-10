# frozen_string_literal: true

class DevicesNetwork < ApplicationRecord
#  belongs_to :device, counter_cache: :networks_count
#  belongs_to :network, counter_cache: :devices
  belongs_to :device
  belongs_to :network
end
