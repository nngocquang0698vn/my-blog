require_relative './has_field'

class HasPLongitude < HasField
  def initialize
    super(:longitude, 'Longitude')
  end
end



