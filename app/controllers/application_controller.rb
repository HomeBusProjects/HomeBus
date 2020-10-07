class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  load_and_authorize_resource
  check_authorization
  
  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
end
