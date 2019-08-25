require 'html-proofer'
require 'microformats'
require_relative '../../lib/predicates'

class HomePageHasMicropubSettings < ::HTMLProofer::Check
  def run
    return unless './public/index.html' == @path
    page = Microformats.parse(@html.to_s)
    [::HasMicropubEndpoint.new].each do |validator|
      begin
        validator.validate(page)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
