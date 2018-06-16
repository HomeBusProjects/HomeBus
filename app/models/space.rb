class Space < ApplicationRecord
  has_and_belongs_to_many :devices
end
