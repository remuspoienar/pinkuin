class Project < ApplicationRecord

  extend SelfAttributesPermitting

  belongs_to :author, class_name: 'User'

  resourcify

  STATUS_ACTIVE   = 'active'.freeze
  STATUS_INACTIVE = 'inactive'.freeze

  VIEW_HANDLERS = {
      created_at: [:strftime, "%d-%m-%Y %H:%M"],
      updated_at: [:strftime, "%d-%m-%Y %H:%M"],
      properties: :to_json
  }

  validates :name, length: { minimum: 6, maximum: 32 }

  def self.for_select_options
    self.pluck(:name, :id)
  end

end
