require_relative './has_field'

class HasEContent < HasField
  def initialize
    super(:content, 'Content')
  end
end
