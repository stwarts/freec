class ApplicationController < ActionController::API
  include Authenticatable
  include Policyable
  include Pagy::Backend

  after_action { pagy_headers_merge(@pagy) if @pagy }
end
