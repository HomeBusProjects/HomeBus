class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :networks_users, dependent: :destroy
  has_many :networks, through: :networks_users

  has_and_belongs_to_many :devices

  after_create :send_admin_mail
  def send_admin_mail
    NotifyRequestMailer.with(user: self).admins_new_user.deliver
  end
end
