require_relative './predicate'
require_relative '../invalid_metadata_error'

class ValidUPhoto < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'Photo is not set' unless hcard.respond_to?(:photo)
    photo = hcard.photo
    raise InvalidMetadataError, 'Photo is not equal to https://www.jvt.me/img/profile.png' unless 'https://www.jvt.me/img/profile.png' == photo
  end
end

