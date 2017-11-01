class Project < ApplicationRecord

  extend SelfAttributesPermitting

  belongs_to :author, class_name: 'User'

  resourcify

  STATUS_ACTIVE   = 'active'.freeze
  STATUS_INACTIVE = 'inactive'.freeze

  validates :name, length: { minimum: 6, maximum: 32 }

end
