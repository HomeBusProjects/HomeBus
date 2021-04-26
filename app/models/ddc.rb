# frozen_string_literal: true

class Ddc < ApplicationRecord
  has_many :permissions
  has_and_belongs_to_many :devices
end
