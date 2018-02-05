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

  # ROLES
  resourcify
  rolify

  ROLE_ACTIONS   = %i[admin read create update destroy].freeze
  ROLE_RESOURCES = [User, Project].freeze

  # pundit
  def self.policy_class
    Admin::UserPolicy
  end


  # VALIDATIONS
  validates :username, length: { minimum: 6, maximum: 32 }



  def self.permitted_attributes
    [:email, :username, :password, :password_confirmation, roles_attributes: %i[_destroy id name resource_type]]
  end

  def self.admin_displayed_columns
    %i[email username confirmed_at sign_in_count last_sign_in_at created_at]
  end

  def self.upload_attributes
    %i[email username]
  end
end
