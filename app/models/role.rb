class Role < ApplicationRecord

  GENERAL    = 'general'.freeze
  SPECIFIC   = 'specific'.freeze
  ROLE_TYPES = [GENERAL, SPECIFIC].freeze

  scopify
  resourcify

  has_many :users_roles, dependent: :destroy
  has_many :users, through: :users_roles

  accepts_nested_attributes_for :users_roles, allow_destroy: true, reject_if: :all_blank

  belongs_to :resource,
             polymorphic: true,
             optional:    true

  scope :generic, -> { where(resource_id: nil) }

  attr_accessor :from_roles_controller

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true

  validates :role_type,
            inclusion:   { in: ROLE_TYPES },
            allow_blank: true,
            allow_nil:   true

  validate :unique_resource_data


  def to_s
    "#{name} : #{resource_type} (#{resource_id.blank? ? GENERAL : resource_id})"
  end

  def role_type
    resource_id.nil? ? GENERAL : SPECIFIC
  end

  def general?
    role_type == GENERAL
  end

  def role_type=(role_type)
    @role_type = role_type
  end

  def resource_id_options
    klass = resource_type.constantize
    klass.public_send(:for_select_options)
  rescue LoadError, NameError => e
    Rails.logger.error e.message
    []
  end

  def self.admin_displayed_columns
    %i(name resource_type resource_id created_at)
  end

  def self.policy_class
    Admin::RolePolicy
  end

  def self.for_select_options
    all.map { |role| [role.to_s, role.id] }
  end

  private

  def unique_resource_data
    if self.class.where(name: name, resource_type: resource_type, resource_id: resource_id).count > 1
      errors.add(:name, "for [#{to_s}] is already used by another role")
    end
  end

end
