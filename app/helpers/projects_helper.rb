module ProjectsHelper

  attr_reader :project

  def author_select_options
    @author_select_options ||= options_for_select(author_collection, project.new_record? ? [] : [author.username, author.id])
  end

  def author_collection
    @author_collection ||= User.all.collect { |u| [u.username, u.id] }
  end

  def author
    @author ||= project.author
  end

end
