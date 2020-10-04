class Ddc < ApplicationRecord
  #  has_and_belongs_to_many :devices
  has_many :ddcs_devices, dependent: :destroy
  has_many :devices, through: :ddcs_devices
end
