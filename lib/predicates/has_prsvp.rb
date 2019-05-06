require_relative './has_field'

class HasPrsvp < HasField
  def initialize
    super(:rsvp, 'RSVP')
  end
end
