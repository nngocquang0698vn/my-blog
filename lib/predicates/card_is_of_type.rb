require_relative './predicate'

class CardIsOfType < Predicate
  def initialize(type)
    @type = type
  end

  def validate(card)
    actual_type = card.type
    raise InvalidMetadataError, "card was not of type `#{@type}`, was `#{actual_type}`" unless @type == actual_type
    true
  end
end
