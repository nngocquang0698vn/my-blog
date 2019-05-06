require 'html-proofer'
require_relative '../../lib/predicates'

class NotesHaveValidHentry < ::HTMLProofer::Check
  def run
    return unless /^\.\/public\/notes\/\w{8}(-\w{4}){3}-\w{12}\/index\.html$/.match? @path
    hentries = @html.css('.h-entry')
    return add_issue('Multiple h-entry found') if 1 < hentries.length
    return add_issue('No h-entry found') if 0 == hentries.length

    entry = Microformats.parse(hentries.to_s).entry
    [::HasPcontent, ::HasUDateTimePublished, ::HasPcategory].each do |clazz|
      begin
        clazz.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    if hentries.css('.p-name').any?
      begin
        ::HasPName.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
