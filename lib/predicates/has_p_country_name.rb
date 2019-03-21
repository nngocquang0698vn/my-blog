require_relative './has_field'

class HasPCountryName < HasField
  def initialize
    super(:country_name, 'Country Name')
  end
end
