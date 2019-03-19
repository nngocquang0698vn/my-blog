require_relative './has_field'

class HasPName < HasField
  def initialize
    super(:name, 'Name')
  end
end
