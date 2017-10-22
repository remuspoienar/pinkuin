class Project < ApplicationRecord

  extend SelfAttributesPermitting

  belongs_to :author, class_name: 'User'

  STATUS_ACTIVE = 'active'.freeze
  STATUS_INACTIVE = 'inactive'.freeze

end
