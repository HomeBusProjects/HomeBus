# frozen_string_literal: true

class AdminController < ApplicationController
  load_and_authorize_resource
  check_authorization

  before_action :authenticate_user!

  def clear_db
    unless Rails.env.development?
      Device.delete_all
      MosquittoAccount.delete_all
      MosquittoAcl.delete_all
      ProvisionRequest.delete_all

      redirect_to provision_requests_path
    end
  end
end
