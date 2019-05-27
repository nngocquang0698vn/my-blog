require 'html-proofer'

module HTMLProofer
  class Check
    # Monkey patch so we don't remove <pre>, <code>, or <tt> elements
    def remove_ignored(html)
      html
    end
  end
end
