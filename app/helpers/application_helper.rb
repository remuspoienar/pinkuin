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
end
