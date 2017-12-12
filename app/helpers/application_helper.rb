module ApplicationHelper
  def bootstrap_class_for_alert(alert_type)
    return 'success' if alert_type.in?(%w[notice success])
    'danger' if alert_type.in?(%w[alert danger])
  end

  def policy?(action)
    policy(policy_subject_class).send(action.to_s << '?')
  end

  def instance_policy?(action)
    policy(policy_subject).send(action.to_s << '?')
  end

  def policy_subject
    send(policy_subject_class.name.downcase)
  end

  def policy_subject_class
    controller.class.name.split('::').last.sub('Controller', '').singularize.constantize
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to(name, '#', class: 'remove_fields')
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub("\n", '')})
  end
end
