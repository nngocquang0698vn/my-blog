require_relative './has_rel'

class HasRelCanonical < ::HasRel
  def initialize
    super(:canonical, 'Canonical URL')
  end
end
