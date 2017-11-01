class Admin::UsersController < ApplicationController
  before_action :set_and_authorize_user!, only: [:show, :edit, :update, :destroy]
  before_action :correct_roles_params, only: [:update]

  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = policy_scope(User).page(params.fetch(:page, 1)).per(params.fetch(:per, 25))
  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    authorize User
    @user = User.new
  end

  # GET /admin/users/1/edit
  def edit
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    authorize User
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_user_path(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to admin_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def correct_roles_params
    roles_attributes                 = user_params.delete(:roles_attributes).to_h.map { |_, v| v }
    params[:user][:roles_attributes] = roles_attributes
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_and_authorize_user!
    @user = User.find(params[:id])
    authorize @user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(*User.permitted_attributes)
  end
end
