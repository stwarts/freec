class UnauthorizedError < StandardError; end

module Policyable
  def authorize!(actor, action, policy_class, record = nil)
    policy_instance = policy_class.new(actor, record)

    is_action_allowed = policy_instance.try("#{action}?")

    raise UnauthorizedError unless is_action_allowed
  end
end
