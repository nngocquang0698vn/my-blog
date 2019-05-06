require_relative './has_field'

class HasUinreplyto < HasField
  def initialize
    super(:in_reply_to, 'Reply')
  end
end
