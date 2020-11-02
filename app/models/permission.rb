class Permission < ApplicationRecord
  belongs_to :device
  belongs_to :network
  belongs_to :ddc
end
