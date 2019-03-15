require_relative './predicate'
require_relative '../invalid_metadata_error'

class ValidUUrl < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'URL is not set' unless hcard.respond_to?(:url)
    url = hcard.url
    raise InvalidMetadataError, 'URL is not equal to https://www.jvt.me' unless 'https://www.jvt.me' == url ||
      'https://www.jvt.me/' == url
  end
end
