require_relative './has_rel'

class HasMicrosubEndpoint < ::HasRel
  def initialize
    super(:microsub, 'microsub endpoint')
  end
end
