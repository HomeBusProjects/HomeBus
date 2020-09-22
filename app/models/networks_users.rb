class NetworksUsers < ActiveRecord::Base
  belongs_to :user, counter_cache: :networks_count
  belongs_to :network, :counter_cache: :users_count
end
