require_relative './has_field'

class HasPDescription < HasField
  def initialize
    super(:description, 'Description')
  end
end



