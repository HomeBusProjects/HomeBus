# frozen_string_literal: true

class NotifyRequestMailer < ApplicationMailer
  default from: 'do-not-reply@homebus.org'

  def new_provisioning_request
    @provision_request = params[:provision_request]
    @user = params[:user]
    mail(to: @user.email, subject: 'New Homebus Request')
  end

  def admins_new_user
    @user = params[:user]
    @url  = 'http://example.com/login'
    if User.where(site_admin: true).count.positive?
      mail(to: User.where(site_admin: true).pluck(:email),
           subject: 'New user')
    end
  end
end
