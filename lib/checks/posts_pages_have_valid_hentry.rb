require 'html-proofer'
require_relative '../../lib/predicates'

class PostsPagesHaveValidHentry < ::HTMLProofer::Check
  def run
    return unless /^.\/public\/posts\/\d{4}\/\d{2}\/\d{2}\//.match? @path
    return unless @html.xpath('//head/meta[@http-equiv="refresh"]').length.zero?
    hentries = @html.css('.h-entry')
    return add_issue('Multiple h-entry found') if 1 < hentries.length
    return add_issue('No h-entry found') if 0 == hentries.length

    entry = Microformats.parse(hentries.to_s).entry
    [::HasUDateTimePublished, ::HasUDateTimeUpdated, ::HasPSummary, ::HasEContent, ::HasUUrl, ::ValidPostUUrl, ::HasPName, ::ValidPauthor, ::HasPcategory, ].each do |clazz|
      begin
        clazz.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    begin
      ::ValidUfeatured.new(::HasUfeatured.new).validate(entry)
    rescue InvalidMetadataError => e
      add_issue(e.message)
    end

    page_mf = Microformats.parse(@html.to_s)
    valid_uuid = ::ValidUuid.new(::HasRelCanonical.new, ::HasUuid.new)
    begin
      valid_uuid.validate(page_mf, entry)
    rescue InvalidMetadataError => e
      add_issue(e.message)
    end
  end
end
