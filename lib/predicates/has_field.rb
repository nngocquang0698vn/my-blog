require_relative './predicate'
require_relative '../invalid_metadata_error'

class HasField < Predicate
  def initialize(field, field_name)
    @field = field
    @field_name = field_name
  end

  def validate(hcard)
    raise InvalidMetadataError, "#{@field_name} is not set" unless hcard.respond_to?(@field)
    contents = hcard.send(@field)
    raise InvalidMetadataError, "#{@field_name} is not set" if contents.to_s.length.zero?
  end
end
