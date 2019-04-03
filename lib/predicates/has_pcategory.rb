require_relative './has_field'

class HasPcategory < ::HasField
  def initialize
    super(:category, 'Category')
  end
end
