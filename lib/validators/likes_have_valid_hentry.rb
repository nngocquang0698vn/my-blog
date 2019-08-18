require 'html-proofer'
require_relative '../../lib/predicates'

class LikesHaveValidHentry < Validator
  def validate(html)
    hentries = html.css('.h-entry')
    entry = Microformats.parse(hentries.to_s).entry

    return false unless entry.respond_to? :like_of

    [::HasUlikeof, ::HasUDateTimePublished, ::HasPcategory].each do |clazz|
      clazz.new.validate(entry)
    end

    true
  end
end
