require_relative './has_field'

class HasUUrl < HasField
  def initialize
    super(:url, 'URL')
  end
end
