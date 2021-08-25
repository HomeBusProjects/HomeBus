class NetworkMonitor < ApplicationRecord
  belongs_to :user
  belongs_to :provision_request, dependent: :destroy
  belongs_to :token, dependent: :destroy

  before_validation :get_token
  after_create :set_token_name

  def get_token
    unless self.token
      self.token = Token.create(name: "network_monitor", scope: 'network_monitor:refresh', enabled: true)
    end
  end

  def set_token_name
    self.token.update(name: "network_monitor #{self.id}")
  end
end
