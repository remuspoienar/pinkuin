class Admin::RolesController < ApplicationController

  before_action :set_and_authorize_role!, only: %i(show edit update destroy)

  before_action :authorize_role_action!, only: %i(index new create)

  # GET /admin/roles
  # GET /admin/roles.json
  def index
    @roles = policy_scope(Role).page(pagination[:page]).per(pagination[:per])
  end

  # GET /admin/roles/1
  # GET /admin/roles/1.json
  def show
  end

  # GET /admin/roles/new
  def new
    @role = Role.new
  end

  # GET /admin/roles/1/edit
  def edit
  end

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if role.save
        current_user.add_role :admin, role
        format.html { redirect_to admin_role_path(role), notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: role }
      else
        format.html { render :new }
        format.json { render json: role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if role.update(role_params) && update_users_roles
        format.html { redirect_to admin_role_path(role), notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: role }
      else
        format.html { render :edit }
        format.json { render json: role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  # DELETE /admin/roles/1.json
  def destroy
    role.destroy
    respond_to do |format|
      format.html { redirect_to admin_roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  attr_reader :role

  # Use callbacks to share common setup or constraints between actions.
  def set_and_authorize_role!
    @role                      = Role.find(params[:id])
    role.from_roles_controller = true
    authorize_role_action!
  end

  def authorize_role_action!
    authorize role || Role
  end

  def update_users_roles
    users_roles_data = all_role_params[:users_roles_attributes].to_h.values
                           .select { |users_role| users_role[:_destroy] == 'false' }
                           .map { |users_role| UsersRole.new(users_role.slice(:user_id)) }

    ActiveRecord::Base.transaction do
      role.users_roles.delete_all
      role.users_roles << users_roles_data
      role.save!
    end
  rescue ActiveRecord::Rollback, ActiveRecord::RecordInvalid
    false
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def all_role_params
    params.require(:role).permit(:name, :resource_type, :role_type, :resource_id, users_roles_attributes: [:user_id, :_destroy])
  end

  def role_params
    all_role_params.except(:users_roles_attributes)
  end

  def pagination
    {
        page: params.fetch(:page, 1),
        per:  params.fetch(:per, 25)
    }
  end

end
