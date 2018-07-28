module ProjectsHelper

  attr_reader :project

  def show_author_field?
    if params[:action] == 'new'
      current_user.has_role?(:admin, Project)
    elsif params[:action] == 'edit'
      current_user.has_role?(:admin, project)
    end
  end

  def show_status_field?
    policy(project).update? || project.new_record?
  end

  def author_select_options
    options_from_collection_for_select(User.all, :id, :username, author&.id)
  end

  def status_select_options
    options_for_select([Project::STATUS_ACTIVE, Project::STATUS_INACTIVE], project.status)
  end

  def author
    @author ||= project.author
  end

end
