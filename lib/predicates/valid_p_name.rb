require_relative './predicate'
require_relative '../invalid_metadata_error'

class ValidPName < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'Name is not set' unless hcard.respond_to?(:name)
    name = hcard.name
    raise InvalidMetadataError, 'Name is not equal to Jamie Tanna' unless 'Jamie Tanna' == name
  end
end


