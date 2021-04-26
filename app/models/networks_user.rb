# frozen_string_literal: true

class NetworksUser < ApplicationRecord
  belongs_to :user, counter_cache: :networks_count
  belongs_to :network, counter_cache: :count_of_users
end
