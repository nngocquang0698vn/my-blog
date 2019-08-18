require 'html-proofer'
require_relative '../../lib/predicates'
require_relative './validator'

class BookmarksHaveValidHentry < Validator
  def validate(html)
    hentries = html.css('.h-entry')
    entry = Microformats.parse(hentries.to_s).entry

    return false unless entry.respond_to? :bookmark_of

    [::HasUbookmarkof, ::HasUDateTimePublished, ::HasPcategory].each do |clazz|
      clazz.new.validate(entry)
    end

    if hentries.css('.p-content').any?
      ::HasPcontent.new.validate(entry)
    end

    if hentries.css('.p-name').any?
      ::HasPName.new.validate(entry)
    end

    true
  end
end
