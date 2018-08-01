class Admin::UsersController < ApplicationController

  before_action :set_and_authorize_user!, only: %i(show edit update destroy)

  before_action :authorize_user_action!, only: %i(new create)

  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = policy_scope(User).page(params.fetch(:page, 1)).per(params.fetch(:per, 25))
  end

  def bulk_upload
    result = ::UserService::Upload.new(users_file).process

    flash_params = if result[:success]
                     { notice: " #{result[:total]} #{'user'.pluralize(result[:total])} created" }
                   else
                     { alert: "Upload was aborted because file contained invalid data. Please fix the problem(s) and try again. Line #{result[:line]} : #{result[:message]}" }
                   end
    redirect_to admin_users_url, flash_params
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    @user = User.new(user_params)
    user.skip_confirmation!

    respond_to do |format|
      if user.save && update_roles
        format.html { redirect_to admin_user_path(user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: user }
      else
        format.html { render :new }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    respond_to do |format|
      if user.update(user_params) && update_user_roles
        format.html { redirect_to admin_user_path(user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: user }
      else
        format.html { render :edit }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  attr_reader :user

  # Use callbacks to share common setup or constraints between actions.
  def set_and_authorize_user!
    @user = User.find(params[:id])
    authorize_user_action!
  end

  def authorize_user_action!
    authorize(user || User)
  end

  def update_user_roles
    result        = ::UserService::Roles.assign(user: user, roles: roles_params)
    flash[:alert] = result[:message] unless result[:success]
    result[:success]
  end

  def update_roles
    current_user.add_role(:admin, user) && update_user_roles
  end

  def all_user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, roles_attributes: %i(_destroy id name resource_type role_type resource_id))
  end

  def user_params
    all_user_params.except(:roles_attributes)
  end

  def roles_params
    all_user_params[:roles_attributes]
  end

  def users_file
    params.permit(:users_file)[:users_file]
  end
end
