class Admin::UserPolicy < ApplicationPolicy

  # actions

  def index?
    general_user_admin? || instance_user_admin? || create?
  end

  def bulk_upload?
    create?
  end

  def show?
    user_admin? || general_user_admin?
  end

  def create?
    user_creator? || general_user_admin?
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

  private

  def user_creator?
    user.has_role? :create, User # create role is only for classes
  end

  def user_admin?
    user.has_role? :admin, record
  end

  def instance_user_admin?
    user.roles_for_any_instance?(:admin, User).any?
  end

  def general_user_admin?
    user.has_role? :admin, User
  end

end
