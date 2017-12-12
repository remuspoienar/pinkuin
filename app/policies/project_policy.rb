class ProjectPolicy < ApplicationPolicy

  def index?
    @index ||= true
  end

  def show?
    @show ||= index?
  end

  def create?
    @create ||= (user.has_role? :create, Project) || project_admin?
  end

  def update?
    @update ||= (record.author == user) || project_admin?
  end

  def destroy?
    @destroy ||= update? || project_admin?
  end

  def project_admin?
    @project_admin ||= user.has_role? :admin, Project
  end

  class Scope < Scope

    def resolve
      @resolve ||= begin
        if user.has_role? :admin, Project
          scope.all
        else
          scope.where(status: Project::STATUS_ACTIVE)
        end
      end
    end
  end

end