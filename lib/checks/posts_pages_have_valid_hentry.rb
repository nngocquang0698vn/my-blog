require 'html-proofer'
require_relative '../../lib/predicates'

class PostsPagesHaveValidHentry < ::HTMLProofer::Check
  def run
    return unless /^.\/public\/posts\/\d{4}\/\d{2}\/\d{2}\//.match? @path
    hentries = @html.css('.h-entry')
    return add_issue('Multiple h-entry found') if 1 < hentries.length
    return add_issue('No h-entry found') if 0 == hentries.length

    entry = Microformats.parse(hentries.to_s).entry
    [::HasUDateTimePublished, ::HasUDateTimeUpdated, ::HasPSummary, ::HasEContent, ::HasUUrl, ::ValidPostUUrl, ::HasPName].each do |clazz|
      begin
        clazz.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
