require 'html-proofer'
require 'microformats'
require_relative '../../lib/predicates'

class HomePageHasValidHcard < ::HTMLProofer::Check
  def run
    return unless './public/index.html' == @path
    node = @html.css('div#jvt-hcard')
    return add_issue('Zero h-cards can be found with ID `#jvt-hcard`') if node.length.zero?

    card = Microformats.parse(node.to_s).card

    [::HasJobDetails.new, ::ValidPLocality.new, ::ValidPName.new, ::ValidUEmail.new, ::ValidUPhoto.new, ::ValidUUrl.new].each do |validator|
      begin
        validator.validate(card)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end
