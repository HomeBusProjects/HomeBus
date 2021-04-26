# frozen_string_literal: true

class NetworksProvisionRequest < ApplicationRecord
  belongs_to :provision_request, counter_cache: :networks_count
  belongs_to :network, counter_cache: :devices_count
end
