require_relative './has_field'

class HasPLatitude < HasField
  def initialize
    super(:latitude, 'Latitude')
  end
end



