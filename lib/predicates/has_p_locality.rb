require_relative './has_field'

class HasPLocality < HasField
  def initialize
    super(:locality, 'Locality')
  end
end
