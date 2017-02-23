FROM alpine:3.5
MAINTAINER Jamie Tanna <docker@jamietanna.co.uk>

# Install NodeJS and Ruby {{{
WORKDIR "/opt/node"

ENV PATH=$PATH:/opt/node/bin

RUN apk update && \
	apk upgrade && \
	# NodeJS {{{
	apk add nodejs && \
	# }}}
	# Ruby {{{
	apk add ruby-dev ruby-bundler && \
	apk add git \
		build-base \
		# for the FFI gem: https://github.com/ffi/ffi/issues/485#issuecomment-191159190
		libffi-dev \
		# for the nokogiri gem: https://github.com/gliderlabs/docker-alpine/issues/53#issuecomment-173412882
		libxml2-dev libxslt-dev
	# }}}
# }}}

# Install package dependencies {{{
RUN mkdir -p /site/_site
WORKDIR "/site"

# https://github.com/docker-library/ruby/issues/45
ENV LANG C.UTF-8

# Ensure that with the new files, we have the right dependencies etc locally {{{
ADD . /site
RUN npm install
ENV PATH=$PATH:/site/node_modules/.bin
RUN bundle install
# }}}

# Build our site {{{
# Finally, we need to build the site, so we've got the latest version of the
# site as part of our image; this means that when deploying, we'll only need to
# mount the _site folder
# }}}
RUN gulp build --production
# }}}

# Default action is to serve the site {{{
CMD ["gulp", "serve"]
# }}}
