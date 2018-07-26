# require 'kaminari/activerecord/active_record_model_extension'

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
      invalid_type_detected = result.map(&:class).map(&:name).map(&:underscore).find { |res| res != resource.to_s }
      raise "Not all elements in result are of type#{resource.to_s.camelize}" if invalid_type_detected

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
      resource_class = resource.to_s.underscore.camelize.constantize
      "#{resource_class}Policy".constantize
    end
  end
end
