class NetworksUser < ActiveRecord::Base
  belongs_to :user, counter_cache: :networks_count
  belongs_to :network, counter_cache: :count_of_users
end
