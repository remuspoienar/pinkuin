class ProjectPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    index?
  end

  def create?
    user.has_role? :create, Project
  end

  def update?
    record.author == user
  end

  def destroy?
    update?
  end

end