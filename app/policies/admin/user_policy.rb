class Admin::UserPolicy < ApplicationPolicy

  def index?
    @index ||= user.has_role? :admin, User
  end

  def bulk_upload?
    @bulk_upload ||= create?
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
end
