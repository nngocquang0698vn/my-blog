require 'html-proofer'
require_relative '../../lib/predicates'

class EventsPagesHaveValidHevent < ::HTMLProofer::Check
  def run
    hevents = @html.css('.h-event')
    event = Microformats.parse(hevents.to_s).event
    [::HasPName, ::HasDtStart, ::HasDtEnd, ::HasPLocation, ::HasPSummary].each do |clazz|
      begin
        clazz.new.validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
