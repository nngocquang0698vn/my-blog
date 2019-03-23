require_relative './has_field'

class HasDtStart < HasField
  def initialize
    super(:start, 'Start')
  end
end
