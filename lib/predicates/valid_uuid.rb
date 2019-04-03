class ValidUuid
  def initialize(has_rel_canonical, has_uuid)
    @has_rel_canonical = has_rel_canonical
    @has_uuid = has_uuid
  end

  def validate(page_mf, entry)
    @has_rel_canonical.validate(page_mf)
    @has_uuid.validate(entry)

    canonical_url = page_mf.rels['canonical'][0]
    uid = entry.uid
    raise InvalidMetadataError, 'rel=canonical does not match u-uid' unless canonical_url == uid
  end
end
