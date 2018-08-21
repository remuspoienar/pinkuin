class RegistrationsController < Devise::RegistrationsController

  def create
    super do
      session['user_id_for_info'] = resource.id
    end
  end

  def after_inactive_sign_up_path_for(resource)
    registration_info_path
  end

  def info
    user_id = session['user_id_for_info']
    return redirect_to root_path if user_id.blank?

    @resource = User.find(user_id)
  end
end