require_relative './has_field'

class HasUbookmarkof < HasField
  def initialize
    super(:bookmark_of, 'Bookmark')
  end
end
