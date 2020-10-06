class NotifyRequestMailer < ApplicationMailer
  default from: 'do-not-reply@homebus.org'

  def new_provisioning_request
    @provision_request = params[:provision_request]
    @user = params[:user]
    mail(to: @user.email, subject: 'New Homebus Request')
  end
end
