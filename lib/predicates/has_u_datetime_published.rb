require_relative './has_field'

class HasUDateTimePublished < HasField
  def initialize
    super(:published, 'Published')
  end
end
