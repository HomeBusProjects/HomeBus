class Device < ApplicationRecord
  belongs_to :provision_request
  has_and_belongs_to_many :spaces

  def friendly_name_and_location
    "#{friendly_name} in #{friendly_location}"
  end
end
