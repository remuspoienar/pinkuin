class User < ApplicationRecord

  # DEVISE
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable

  # ASSOCIATIONS
  has_many :projects, foreign_key: :author_id
  has_many :users_roles
  has_many :roles, through: :users_roles

  accepts_nested_attributes_for :roles, allow_destroy: true, reject_if: :all_blank

  # VALIDATIONS
  validates :username, length: { minimum: 6, maximum: 32 }

  # ROLES
  resourcify
  rolify

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
