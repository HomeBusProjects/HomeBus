# frozen_string_literal: true

class DdcsDevice < ApplicationRecord
  belongs_to :ddc
  belongs_to :device
end
