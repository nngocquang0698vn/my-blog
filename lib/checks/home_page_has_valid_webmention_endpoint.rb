require 'html-proofer'
require_relative '../../lib/predicates/valid_webmention_endpoint'

class HomePageHasValidWebmentionEndpoint < ::HTMLProofer::Check
  def run
    return unless './public/index.html' == @path
    validator = ValidWebmentionEndpoint.new
    element = @html.at('link[rel="webmention"]')
    href = if element
             element['href']
           else
             nil
           end
    begin
      validator.validate(href)
    rescue InvalidWebmentionEndpointError => e
      add_issue(e.message)
    end
  end
end
