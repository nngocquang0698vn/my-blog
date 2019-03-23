require 'html-proofer'
require_relative '../../lib/predicates'

class EventsPagesHaveValidHevent < ::HTMLProofer::Check
  def run
    return unless /^.\/public\/events\/[a-zA-Z0-9-]+\/\d{4}\/\d{2}\/\d{2}\//.match? @path
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
        ::HasHAdr.new(::HasField.new(:location, 'Location'),
                      ::CardIsOfType.new('h-adr'),
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
        ::HasHGeo.new(::HasField.new(:location, 'Location'),
                      ::CardIsOfType.new('h-geo'),
                      ::HasPLatitude.new,
                      ::HasPLongitude.new)
          .validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end

    unless hevents.css('.p-location.h-card').length.zero?
      begin
        ::EventHasHcardInPlocation.new(::HasField.new(:location, 'Location'),
                      ::CardIsOfType.new('h-card'),
                      ::HasPStreetAddress.new,
                      ::HasPLocality.new,
                      ::HasPCountryName.new,
                      ::HasPPostalCode.new,
                      ::HasPLatitude.new,
                      ::HasPLongitude.new)
          .validate(event)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
