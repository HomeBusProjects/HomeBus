# frozen_string_literal: true

class User < ApplicationRecord
  self.implicit_order_column = "created_at"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #  devise :database_authenticatable, :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :networks_users, dependent: :destroy
  has_many :networks, through: :networks_users

  has_many :provision_requests, dependent: :destroy
  has_many :app_instances, dependent: :destroy
  has_many :tokens, dependent: :destroy

  has_and_belongs_to_many :devices

  before_create :set_name
  after_create :send_admin_mail

  def set_name
    if self.name.nil?
      self.name = self.email
    end
  end

  def send_admin_mail
    NotifyRequestMailer.with(user: self).admins_new_user.deliver_later
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def approve!
    self.approved = true
    save
  end
end
