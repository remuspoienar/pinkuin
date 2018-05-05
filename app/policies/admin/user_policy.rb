class Admin::UserPolicy < ApplicationPolicy

  # actions

  def index?
    general_user_admin? || instance_user_admin? || create?
  end

  def bulk_upload?
    create?
  end

  def show?
    user_admin? || general_user_admin? || self?
  end

  def create?
    user_creator? || general_user_admin?
  end

  def update?
    show? && !self?
  end

  def destroy?
    show? && !self?
  end

  # scope

  class Scope < Scope

    def resolve
      @resolve ||= begin
        if user.has_role? :admin, User
          scope.all
        elsif (roles = user.roles_for_any_instance?(:admin, User)).any?
          scope.where(id: roles.pluck(:resource_id) << user.id)
        else
          scope.where(id: user.id)
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

  def self?
    user.id == record.id
  end

end
