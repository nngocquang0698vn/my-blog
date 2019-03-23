require_relative './has_field'

class HasPStreetAddress < HasField
  def initialize
    super(:street_address, 'Street Address')
  end
end
