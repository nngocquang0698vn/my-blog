require_relative './has_field'

class HasPLocation < HasField
  def initialize
    super(:location, 'Location')
  end
end


