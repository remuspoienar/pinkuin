class ProjectPolicy < ApplicationPolicy

  # actions

  def index?
    general_project_admin? || instance_project_admin? || create?
  end

  def show?
    project_admin? || general_project_admin?
  end

  def create?
    project_creator? || general_project_admin?
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
        if user.has_role? :admin, Project
          scope.all
        else
          scope.where(status: Project::STATUS_ACTIVE)
        end
      end
    end
  end

  private

  def project_creator?
    user.has_role? :create, Project
  end

  def project_admin?
    record.author_id == user.id
  end

  def instance_project_admin?
    user.projects.any?
  end

  def general_project_admin?
    user.has_role? :admin, Project
  end

end