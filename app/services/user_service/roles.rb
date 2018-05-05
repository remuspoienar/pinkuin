class UserService::Roles

  def initialize(user:, roles:)
    @user  = user
    @roles = roles.to_h.values
                 .map { |role| role.slice(:name, :resource_type, :resource_id, :_destroy) }
                 .map { |role| role[:resource_id] = nil if role[:resource_id] == ''; role }
  end

  def assign
    ActiveRecord::Base.transaction do
      roles.each { |role_data| handle_role(role_data) }
      { success: true }
    end
  rescue ActiveRecord::Rollback, ActiveRecord::RecordInvalid => e
    { success: false, message: e.message }
  end

  private

  attr_reader :user, :roles

  def handle_role(role_data)
    destroy = role_data.delete(:_destroy).in?([true, 'true'])
    role    = find_role(role_data)

    return destroy_role_link(role) if destroy

    if role.blank?
      create_and_link_role!(role_data)
    else
      create_link!(role) unless link_exists?(role)
    end
  end

  def find_role(data)
    Role.find_by(data)
  end

  def create_and_link_role!(data)
    user.roles.create!(data)
  end

  def create_link!(role)
    user.users_roles.create!(role_id: role.id)
  end

  def link_exists?(role)
    user.users_roles.exists?(role_id: role.id)
  end

  def destroy_role_link(role)
    UsersRole.where(user_id: user.id, role_id: role.id).delete_all
    if role.reload.users_roles.blank?
      role.destroy!
    end
  end

end