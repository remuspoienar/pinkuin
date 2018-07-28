module Support
  module AuthHelper
    extend self

    def authorize_action_on_resource(action, resource, success = true)
      policy_instance_method = "#{action}?".to_sym
      policy_mock            = double("Policy class for #{resource.to_s.pluralize}", policy_instance_method => success)

      allow(Pundit).to receive(:policy!).and_return(policy_mock)
    end

    def set_resource_scope(resource, result)
      result                = Array(result)
      resource_class        = resource_class(resource)
      invalid_type_detected = result.find { |result_el| !(result_el.is_a?(resource_class) || result_el.is_a?(RSpec::Mocks::TestDouble)) }
      raise "Not all elements in result are of type #{resource.to_s.camelize}" if invalid_type_detected

      scope_mock = Kaminari.paginate_array(Array(result))
      allow(Pundit).to receive(:policy_scope!).and_return(scope_mock)
    end

    def fail_authorization_for_action_on_resource(action, resource)
      authorize_action_on_resource(action, resource, false)
    end

    def authenticate_user(user)
      warden = request.env['warden']

      allow(warden).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end

    private

    def policy_class_for_resource(resource)
      "#{resource_class(resource)}Policy".constantize
    end

    def resource_class(name)
      name.to_s.underscore.camelize.constantize
    end
  end
end
