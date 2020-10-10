class UserMailer < ApplicationMailer
  default from: 'do-not-reply@homebus.org'

  def notify_admins
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: User.where(site_admn: true).pluck(:email), subject: 'New user')
  end
end
