require_relative './has_field'

class HasUuid < ::HasField
  def initialize
    super(:uid, 'UID')
  end
end
