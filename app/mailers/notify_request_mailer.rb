class NotifyRequestMailer < ApplicationMailer
  default from: 'homebus-notify@romkey.com'

  def new_provisioning_request
    @provision_request = params[:provision_request]
    mail(to: 'romkey@romkey.com', subject: 'New Provisioning Request')
  end
end
