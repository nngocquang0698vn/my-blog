require_relative './has_field'

class HasPcontent < HasField
  def initialize
    super(:content, 'Content')
  end
end
