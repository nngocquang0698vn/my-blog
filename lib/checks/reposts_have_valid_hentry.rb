require 'html-proofer'
require_relative '../../lib/predicates'

class RepostsHaveValidHentry < ::HTMLProofer::Check
  def run
    return unless /^\.\/public\/reposts\/\w{8}(-\w{4}){3}-\w{12}\/index\.html$/.match? @path
    hentries = @html.css('.h-entry')
    entry = Microformats.parse(hentries.to_s).entry

    [::HasUrepostof, ::HasUDateTimePublished, ::HasPcategory].each do |clazz|
      begin
        clazz.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    if hentries.css('.p-content').any?
      begin
        ::HasPcontent.new.validate(entry)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
