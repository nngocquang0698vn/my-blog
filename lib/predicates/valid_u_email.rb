require_relative './predicate'
require_relative '../invalid_metadata_error'

class ValidUEmail < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'Email is not set' unless hcard.respond_to?(:email)
    email = hcard.email
    raise InvalidMetadataError, 'Email is not equal to mailto:hi@jamietanna.co.uk' unless 'mailto:hi@jamietanna.co.uk' == email
  end
end

