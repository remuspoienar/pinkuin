class ApplicationController < ActionController::Base
  include Pundit

  layout 'application'

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound, StandardError, RuntimeError do |e|
    Raven.capture_exception(e)
    raise e
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
