require 'html-proofer'
require_relative '../predicates'

class PostsPagesHaveSyndicationLink < ::HTMLProofer::Check
  def run
    return unless /^.\/public\/posts\/\d{4}\/\d{2}\/\d{2}\//.match? @path
    hentries = @html.css('.h-entry')
    return unless hentries.css('#syndication-targets').any?
    entry = Microformats.parse(hentries.to_s).entry

    return add_issue('No u-syndication links found') unless entry.respond_to?(:syndication)
    return add_issue('No u-syndication links found') if entry.syndication.length.zero?
  end
end
