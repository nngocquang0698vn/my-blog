require_relative './predicate'
require_relative '../invalid_metadata_error'

class ValidPLocality < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'Locality is not set' unless hcard.respond_to?(:locality)
    locality = hcard.locality
    raise InvalidMetadataError, 'Locality is not Nottingham' unless 'Nottingham' == locality
  end
end
