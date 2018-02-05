require 'csv'

class UserService::Upload

  def initialize(file)
    @rows   = CSV.read(file.path)
    @header = rows.shift.map(&:squish)
  end

  def process
    ActiveRecord::Base.transaction do
      rows.each_with_index do |row, line|
        @line  = line + 1
        user_params = { roles_attributes: [] }
        row.each_with_index do |value, index|
          column = header[index].to_sym

          if User.upload_attributes.include?(column)
            user_params[column] = value
          elsif User::ROLE_ACTIONS.include?(column)
            user_params[:roles_attributes] += value.split(/[[:space:]]/).map { |resource| { name: column.to_s, resource_type: resource.classify } } unless value.blank?
          end
        end

        pass                                = Rails.env.development? ? ENV['DEFAULT_DEV_PASSWORD'].to_s : SecureRandom.uuid
        user_params[:password]              = pass
        user_params[:password_confirmation] = pass

        user = User.new(user_params)
        user.skip_confirmation!
        user.save!
      end
    end

    { success: true, total: rows.count }

  rescue ActiveRecord::RecordInvalid => e

    { success: false, line: @line, message: e.message }
  end

  private

  attr_reader :rows, :header
end
