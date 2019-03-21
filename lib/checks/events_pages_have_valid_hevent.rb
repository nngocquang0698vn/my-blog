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

    unless hevents.css('.p-description').length.zero?
      begin
        ::HasPDescription.new.validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    unless hevents.css('.h-adr').length.zero?
      begin
        ::HasHAdr.new(::HasField.new(:adr, 'Address'),
                      ::HasPStreetAddress.new,
                      ::HasPLocality.new,
                      ::HasPCountryName.new,
                      ::HasPPostalCode.new)
          .validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    unless hevents.css('.h-geo').length.zero?
      begin
        ::HasHGeo.new(::HasField.new(:geo, 'Geo'),
                      ::HasPLatitude.new,
                      ::HasPLongitude.new)
          .validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
