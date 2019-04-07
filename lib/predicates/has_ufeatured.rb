require_relative './has_field'

class HasUfeatured < HasField
  def initialize
    super(:featured, 'Featured image')
  end
end
