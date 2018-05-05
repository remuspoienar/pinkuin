class Admin::RolePolicy < ApplicationPolicy

  # actions

  def index?
    general_role_admin? || instance_role_admin? || create?
  end

  def bulk_upload?
    create?
  end

  def show?
    role_admin? || general_role_admin?
  end

  def create?
    role_creator? || general_role_admin?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  # scope

  class Scope < Scope

    def resolve
      if user.has_role? :admin, Role
        scope.all
      elsif (roles = user.roles_for_any_instance?(:admin, Role)).any?
        scope.where(id: roles.pluck(:resource_id))
      else
        scope.where(id: nil)
      end

    end
  end

  private

  def role_creator?
    user.has_role? :create, Role # create role is only for classes
  end

  def role_admin?
    user.has_role? :admin, record
  end

  def instance_role_admin?
    user.roles_for_any_instance?(:admin, Role).any?
  end

  def general_role_admin?
    user.has_role? :admin, Role
  end


end
