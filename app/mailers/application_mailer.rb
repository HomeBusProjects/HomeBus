# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@homebus.org'
  layout 'mailer'
  deliver_later_queue_name :default
end
