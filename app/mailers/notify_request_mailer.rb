class NotifyRequestMailer < ApplicationMailer
  default from: 'homebus-notify@romkey.com'

  def request
    @provision_request = params[:provision_request]
    mail(to: 'romkey@romkey.com', subject: 'New Provisioning Request')
  end
end
