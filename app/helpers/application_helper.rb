module ApplicationHelper
  def bootstrap_class_for_alert(alert_type)
    return 'success' if alert_type.in?(%w[notice success])
    'danger' if alert_type.in?(%w[alert danger])
  end
end
