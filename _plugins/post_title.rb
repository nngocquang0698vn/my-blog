module Jekyll
  module Tags
    class PostTitle < Liquid::Tag
      def initialize(tag_name, post, tokens)
        super
        @orig_post = post.strip
        begin
          @post = PostComparer.new(@orig_post)
        rescue StandardError => e
          raise Jekyll::Errors::PostURLError, <<-MSG
Could not parse name of post "#{@orig_post}" in tag 'post_title'.
Make sure the post exists and the name is correct.
#{e.class}: #{e.message}
MSG
        end
      end

      def render(context)
        site = context.registers[:site]

        site.posts.docs.each do |p|
          return p.data['title'] if @post == p
        end

        # New matching method did not match, fall back to old method
        # with deprecation warning if this matches

        site.posts.docs.each do |p|
          next unless @post.deprecated_equality p
          Jekyll::Deprecator.deprecation_message "A call to "\
            "'{% post_title #{@post.name} %}' did not match " \
            "a post using the new matching method of checking name " \
            "(path-date-slug) equality. Please make sure that you " \
            "change this tag to match the post's name exactly."
          return p.url
        end

        raise Jekyll::Errors::PostURLError, <<-MSG
Could not find post "#{@orig_post}" in tag 'post_title'.
Make sure the post exists and the name is correct.
MSG
      end
    end
  end
end

Liquid::Template.register_tag("post_title", Jekyll::Tags::PostTitle)
