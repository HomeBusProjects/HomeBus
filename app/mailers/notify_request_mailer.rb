class NotifyRequestMailer < ApplicationMailer
  default from: 'do-not-reply@homebus.io'

  def new_provisioning_request
    @provision_request = params[:provision_request]
    mail(to: 'romkey@romkey.com', subject: 'New Provisioning Request')
  end
end
