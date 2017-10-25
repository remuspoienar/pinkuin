module ProjectsHelper

  def policy?(action)
    policy(Project).send(action.to_s << '?')
  end

  def instance_policy?(action)
    policy(project).send(action.to_s << '?')
  end

  def author_select_options
    @author_select_options ||= options_for_select(author_collection, project.new_record? ? [] : [author.username, author.id])
  end

  def author_collection
    @author_collection ||= User.all.collect { |u| [u.username, u.id] }
  end

  def author
    @author ||= project.author
  end

  def project
    @project
  end
end
