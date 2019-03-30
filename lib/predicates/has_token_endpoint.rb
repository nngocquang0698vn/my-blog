require_relative './has_rel'

class HasTokenEndpoint < ::HasRel
  def initialize
    super(:token_endpoint, 'token_endpoint')
  end
end

