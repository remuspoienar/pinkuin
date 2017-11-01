module Admin::UsersHelper

  def minimum_password_length
    @minimum_password_length ||= 6
  end

  def user
    @user
  end

end
