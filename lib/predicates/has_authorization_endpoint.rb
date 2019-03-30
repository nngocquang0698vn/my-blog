require_relative './has_rel'

class HasAuthorizationEndpoint < ::HasRel
  def initialize
    super(:authorization_endpoint, 'authorization_endpoint')
  end
end
