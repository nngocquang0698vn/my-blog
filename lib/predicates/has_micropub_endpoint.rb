require_relative './has_rel'

class HasMicropubEndpoint < ::HasRel
  def initialize
    super(:micropub, 'micropub endpoint')
  end
end
