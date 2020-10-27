class ProvisionRequest < ApplicationRecord
  enum status: [ :unanswered, :accepted, :denied ]

  has_many :devices, dependent: :delete_all

  has_one :mosquitto_account
  has_many :mosquitto_acl

  belongs_to :network

  scope :owned_by, -> (user) { ProvisionRequest.where(network_id: user.networks.pluck(:id)) }

  def get_refresh_token(user)
    payload = {
      kind: 'refresh',
      provision_request: {
        name: friendly_name,
        id: self.id
      },
      user: {
        id: user.id
      }
    }

    JsonWebToken.encode(payload, Time.now + 1.year)
  end

  def accept!
    accepted!

    ro_ddcs.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    wo_ddcs.each do |ddc_name|
      Ddc.where(name: ddc_name).first_or_create(description: '', reference_url: '')
    end

    requested_uuid_count.times do |i|
      device = self.devices.create friendly_name: "#{friendly_name}-#{i}"

      device.networks << network
      device.users << network.users.first

      ro_ddcs.each do |ddc_name|
        ddc = Ddc.find_by name: ddc_name

        device.ddcs << ddc
        device.ddcs_devices.where(ddc: ddc).update(consumable: true)
      end

      wo_ddcs.each do |ddc_name|
        ddc = Ddc.find_by name: ddc_name

        device.ddcs << ddc
        device.ddcs_devices.where(ddc: ddc).update(publishable: true)
      end
    end


    self.create_mosquitto_account(superuser: true, password: SecureRandom.base64(32), enabled: true)

    MosquittoAcl.from_provision_request self
  end

  def revoke!
    self.mosquitto_account.update(enabled: false)
  end

  def self.find_by_refresh_token(token)
    begin
      request = JsonWebToken.decode(token)

      if Time.now.to_i > request["exp"]
        return nil
      end

      ProvisionRequest.find request["provision_request"]["id"]
    rescue
      nil
    end
  end

end
