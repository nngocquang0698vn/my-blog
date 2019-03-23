require_relative './has_field'

class HasPPostalCode < HasField
  def initialize
    super(:postal_code, 'Postal Code')
  end
end
