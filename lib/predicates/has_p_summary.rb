require_relative './has_field'

class HasPSummary < HasField
  def initialize
    super(:summary, 'Summary')
  end
end
