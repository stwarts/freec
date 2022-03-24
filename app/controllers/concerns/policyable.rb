class UnauthorizedError < StandardError; end

module Policyable
  def authorize!(actor, action, policy_class)
    policy_instance = policy_class.new(actor)

    is_action_allowed = policy_instance.try("#{action}?")

    raise UnauthorizedError unless is_action_allowed
  end
end
