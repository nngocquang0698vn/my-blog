FROM klakegg/hugo:0.58.3-ext-alpine AS hugo
RUN apk --update add git tzdata && \
	cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
	echo 'Europe/London' > /etc/timezone
ENV HUGO_DESTINATION /public
WORKDIR /site
COPY ./ /site
RUN hugo --destination=/public --verbose --enableGitInfo

FROM ruby:2.5-alpine
MAINTAINER Jamie Tanna <docker@jamietanna.co.uk>

# Install Ruby {{{
RUN apk --update add git \
		build-base
# }}}

WORKDIR /app
COPY Gemfile Gemfile.lock  /app/
COPY --from=hugo /public public
# Don't pull in deploy dependencies as they're a separate Docker image
ENV BUNDLE_WITHOUT=deploy
RUN bundle install
# get our dependencies for testing {{{
COPY permalinks.yml /app/
COPY Rakefile ./
COPY lib/ ./lib
COPY spec/ ./spec
COPY .schema/ ./.schema
# }}}
RUN bundle exec rake validate && \
	bundle exec rake test
# allow this to fail so we don't break the build on external links erroring
# (possibly intermittently)
RUN bundle exec rake test:links || true

# Final, built image
FROM scratch
WORKDIR /
COPY --from=hugo /public /site
