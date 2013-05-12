class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  after_create :send_welcome_email
  
  # Override Devise methods
  # no password is required when the account is created; validata password when user sets one
  validates_confirmation_of :password
  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

  # Override Devise method
  def confirmation_required?
    false
  end

  # Override Devise method
  def active_for_authentication?
    confirmed? || confirmation_period_valid?
  end

  # Override Devise method
  def send_reset_password_instructions
    if self.confirmed?
      super
    else
      errors.add :base, "You must receive and invitation before you set your password."
    end
  end

  private

  def send_welcome_email
    return if email.include?(ENV['ADMIN_EMAIL'])
    UserMailer.welcome_email(self).deliver
  end

end
