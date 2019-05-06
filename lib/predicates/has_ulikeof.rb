require_relative './has_field'

class HasUlikeof < HasField
  def initialize
    super(:like_of, 'Like')
  end
end
