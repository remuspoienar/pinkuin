class Admin::UserPolicy < ApplicationPolicy

  def index?
    user_admin? || instance_user_admin? || create?
  end

  def bulk_upload?
    create?
  end

  def show?
    user_admin?
  end

  def create?
    user_admin? || user.has_role?(:create, User)
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def user_admin?
    user.has_role? :admin, record
  end

  def instance_user_admin?
    user.roles_for_any_instance?(:admin, User).any?
  end

  class Scope < Scope

    def resolve
      @resolve ||= begin
        if user.has_role? :admin, User
          scope.all
        elsif (roles = user.roles_for_any_instance?(:admin, User)).any?
          scope.where(id: roles.pluck(:resource_id))
        else
          User.where(id: nil)
        end
      end
    end
  end
end
