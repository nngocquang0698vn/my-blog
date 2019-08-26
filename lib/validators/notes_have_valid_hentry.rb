require 'html-proofer'
require_relative '../../lib/predicates'

class NotesHaveValidHentry < Validator
  def validate(html)
    hentries = html.css('.h-entry')

    entry = Microformats.parse(hentries.to_s).entry
    [::HasPcontent, ::HasUDateTimePublished].each do |clazz|
      clazz.new.validate(entry)
    end

    if hentries.css('.p-category').any?
      ::HasPcategory.new.validate(entry)
    end

    if hentries.css('.p-name').any?
      ::HasPName.new.validate(entry)
    end

    true
  end
end
