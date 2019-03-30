require 'html-proofer'
require 'microformats'
require_relative '../../lib/predicates'

class HomePageHasIndieauthSettings < ::HTMLProofer::Check
  def run
    return unless './public/index.html' == @path
    page = Microformats.parse(@html.to_s)
    [::HasAuthorizationEndpoint.new, ::HasTokenEndpoint.new].each do |validator|
      begin
        validator.validate(page)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
