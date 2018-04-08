module Admin::UsersHelper

  attr_reader :user

  def minimum_password_length
    @minimum_password_length ||= 6
  end

end
