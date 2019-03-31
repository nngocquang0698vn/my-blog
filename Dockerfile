FROM klakegg/hugo:0.54.0-ext-alpine AS hugo
WORKDIR /site
COPY ./ /site
RUN apk --update add git && \
	hugo -d public --enableGitInfo --minify

FROM scratch
WORKDIR /
COPY --from=hugo /site/public /site
