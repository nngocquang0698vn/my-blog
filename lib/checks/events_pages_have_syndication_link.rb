require 'html-proofer'
require_relative '../predicates'

class EventsPagesHaveSyndicationLink < ::HTMLProofer::Check
  def run
    return unless /^.\/public\/events\/[a-zA-Z0-9-]+\/\d{4}\/\d{2}\/\d{2}\//.match? @path
    hevents = @html.css('.h-event')
    return unless hevents.css('#syndication-targets').any?
    event = Microformats.parse(hevents.to_s).event

    return add_issue('No u-syndication links found') unless event.respond_to?(:syndication)
    return add_issue('No u-syndication links found') if event.syndication.length.zero?
  end
end
