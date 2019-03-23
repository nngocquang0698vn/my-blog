require_relative './predicate'
require_relative '../invalid_metadata_error'

class HasField < Predicate
  def initialize(field, field_name)
    @field = field
    @field_name = field_name
    @fail_if_field_not_found = true
  end

  def validate(hcard)
    unless hcard.respond_to?(@field)
      return unless @fail_if_field_not_found
      raise InvalidMetadataError, "#{@field_name} is not set"
    end
    contents = hcard.send(@field)
    raise InvalidMetadataError, "#{@field_name} is not set" if contents.to_s.length.zero?
  end

  def fail_if_field_not_found(should_fail)
    @fail_if_field_not_found = should_fail
    self
  end
end
