require_relative './predicate'
require_relative '../invalid_metadata_error'

class HasJobDetails < Predicate
  def validate(hcard)
    raise InvalidMetadataError, 'p-job-title not set' if !hcard.respond_to?(:job_title) ||
      hcard.job_title.empty?

    raise InvalidMetadataError, 'p-org not set' if !hcard.respond_to?(:org)

    org = hcard.org
    raise InvalidMetadataError, 'p-org.p-name not set' if !org.respond_to?(:name) ||
      org.name.empty?
    raise InvalidMetadataError, 'p-org.u-url not set' if !org.respond_to?(:url) ||
      org.url.empty?
  end
end


