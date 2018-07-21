module Support
  module AuthHelper
    extend self

    def authorize_action_on_resource(action, resource)
      resource_class = resource.is_a?(Class) ? resource : resource.class
      policy_class   = resource_class.respond_to?(:policy_class) ? resource_class.policy_class : "#{resource_class.name}Policy".constantize

      policy_instance_method = "#{action}?".to_sym
      return unless policy_class.instance_methods.include?(policy_instance_method)

      allow_any_instance_of(policy_class).to receive(policy_instance_method).and_return(true)
    end

    def authenticate_user(user)
      sign_in(user)
    end
  end
end