class Admin::UserPolicy < ApplicationPolicy

  def index?
    user_admin?
  end

  def bulk_upload?
    create?
  end

  def show?
    @show ||= index?
  end

  def create?
    @create ||= index?
  end

  def update?
    @update ||= create?
  end

  def destroy?
    @destroy ||= update?
  end

  def user_admin?
    user.has_role? :admin, User
  end
end
