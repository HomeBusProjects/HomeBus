class ApplicationController < ActionController::Base
  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end
end
