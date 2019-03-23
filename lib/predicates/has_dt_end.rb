require_relative './has_field'

class HasDtEnd < HasField
  def initialize
    super(:end, 'End')
  end
end

