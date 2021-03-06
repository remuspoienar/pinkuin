class User < ApplicationRecord

  # DEVISE
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  def send_devise_notification(notification, *args)
    OutgoingEmailWorker.perform_async(notification, id, *args)
  end

  # ASSOCIATIONS
  has_many :projects, foreign_key: :author_id, dependent: :destroy
  has_many :users_roles, dependent: :destroy#, validate: true
  has_many :roles, through: :users_roles#, validate: true

  accepts_nested_attributes_for :users_roles, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :roles, allow_destroy: true, reject_if: :all_blank

  # VALIDATIONS
  validates :username, length: { minimum: 6, maximum: 32 }

  # ROLES
  resourcify
  rolify

  def self.for_select_options
    self.pluck(:email, :id)
  end

  ROLE_ACTIONS   = %i(admin read create update destroy).freeze
  ROLE_RESOURCES = [User, Project].freeze

  def roles_for_any_instance?(role, klass)
    klass.send(:find_roles, role.to_sym, self).where.not(resource_id: nil)
  rescue NoMethodError
    []
  end

  # pundit
  def self.policy_class
    Admin::UserPolicy
  end

  # views helpers custom config
  VIEW_HANDLERS = {
      confirmed_at:    [:strftime, "%d-%m-%Y %H:%M"],
      last_sign_in_at: [:strftime, "%d-%m-%Y %H:%M"],
      created_at:      [:strftime, "%d-%m-%Y %H:%M"]
  }

  def self.admin_displayed_columns
    %i(email username confirmed_at sign_in_count last_sign_in_at created_at)
  end

  # services config
  def self.upload_attributes
    %i(email username)
  end

end
