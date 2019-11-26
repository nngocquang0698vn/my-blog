require 'html-proofer'

class NoTwitterWidgets < ::HTMLProofer::Check
  def run
    twitter_scripts = @html.css('script').select do |script|
      !script.attr(:src).nil? && script.attr(:src).include?('/platform.twitter.com/widgets.js')
    end
    add_issue('Twitter widget found on the site - please remove it for privacy concerns') unless twitter_scripts.length.zero?
  end
end
