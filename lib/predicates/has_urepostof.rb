require_relative './has_field'

class HasUrepostof < HasField
  def initialize
    super(:repost_of, 'Repost')
  end
end

