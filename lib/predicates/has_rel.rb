require_relative './predicate'
require_relative '../invalid_metadata_error'

class HasRel < ::Predicate
  def initialize(rel, rel_name)
    @rel = rel
    @rel_name = rel_name
  end

  def validate(page)
    rels = page.rels

    if rels.has_key?(@rel)
      rel_value = rels[@rel]
    elsif rels.has_key?(@rel.to_s)
      rel_value = rels[@rel.to_s]
    else
      raise InvalidMetadataError, "No #{@rel_name} found"
    end

    raise InvalidMetadataError, "No #{@rel_name} found" if rel_value.length.zero?
    if rel_value.is_a? Array
      raise InvalidMetadataError, "No #{@rel_name} found" if rel_value[0].length.zero?
    end
  end
end
