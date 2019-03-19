require_relative './has_field'

class HasUDateTimeUpdated < HasField
  def initialize
    super(:updated, 'Updated')
  end
end
