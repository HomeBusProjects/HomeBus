class AdminController < ApplicationController
  def clear_db
    Device.delete_all
    MosquittoAccount.delete_all
    MosquittoAcl.delete_all
    ProvisionRequest.delete_all

    redirect_to provision_requests_path
  end
end