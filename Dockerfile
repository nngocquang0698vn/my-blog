FROM alpine:3.5
MAINTAINER Jamie Tanna <docker@jamietanna.co.uk>

# Install NodeJS and Ruby {{{
WORKDIR "/opt/node"

ENV PATH=$PATH:/opt/node/bin

RUN apk update && \
	apk upgrade && \
	# Required to set timezone {{{
	apk add tzdata && \
	# }}}
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

# Ensure timezone is set correctly {{{
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo 'Europe/London' > /etc/timezone
# }}}

# Install package dependencies {{{
RUN mkdir -p /app/site/_site
WORKDIR "/app"

# https://github.com/docker-library/ruby/issues/45
ENV LANG C.UTF-8

# Set /app as the initial directory for the dependencies, allowing the site to
# then be mounted into /app/site, so we don't override any of our
# pre-downloaded NPM dependencies {{{
# Ensure we have the latest Node dependencies, which should be changed less
# often than the Ruby dependencies (ie Jekyll, Capistrano) so will want to be
# cached longer {{{
COPY package.json /app/
RUN npm install
ENV PATH=$PATH:/app/node_modules/.bin
# }}}
# Ensure we have the latest Ruby dependencies {{{
COPY Gemfile Gemfile.lock /app/
# Don't pull in deploy dependencies as they're a separate Docker image
ENV BUNDLE_WITHOUT=deploy
RUN bundle install
# }}}
# }}}

# Once set up, use our mounted directory for the site
WORKDIR "/app/site"

# Default action is to serve the site {{{
CMD ["gulp", "serve"]
# }}}
