require 'html-proofer'
require_relative '../../lib/validators'

class Mf2HasValidHentry < ::HTMLProofer::Check
  def run
    return unless /^\.\/public\/mf2\/\w{8}(-\w{4}){3}-\w{12}\/index\.html$/.match? @path
    return unless @html.xpath('//head/meta[@http-equiv="refresh"]').length.zero?
    return if @html.css('.h-entry').length.zero?

    [
      BookmarksHaveValidHentry,
      LikesHaveValidHentry,
      RepliesHaveValidHentry,
      RepostsHaveValidHentry,
      RsvpsHaveValidHentry,
      NotesHaveValidHentry,
    ].each do |clazz|
      begin
        # don't carry on validating if we've already successfully validated it
        break if clazz.new.validate(@html)
      rescue InvalidMetadataError => e
        add_issue(e.message)
      end
    end
  end
end

