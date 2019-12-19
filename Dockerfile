FROM registry.gitlab.com/jamietanna/jvt.me/hugo-base:0.58.3 AS hugo
COPY ./ /site
RUN hugo --destination=/public --verbose --minify

FROM registry.gitlab.com/jamietanna/jvt.me/ruby-base:v1

COPY --from=hugo /public public
# get our dependencies for testing {{{
COPY permalinks.yml /app/
COPY Rakefile ./
COPY lib/ ./lib
COPY spec/ ./spec
COPY .schema/ ./.schema
# }}}
RUN bundle exec rake validate && \
	bundle exec rake test

# Final, built image
FROM scratch
WORKDIR /
COPY --from=hugo /public /site
