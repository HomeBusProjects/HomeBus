class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
end
