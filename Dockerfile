FROM klakegg/hugo:0.54.0-ext-alpine AS hugo
WORKDIR /site
COPY ./ /site
RUN apk --update add git tzdata && \
	cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
	echo 'Europe/London' > /etc/timezone && \
	hugo -d public --enableGitInfo --minify

FROM scratch
WORKDIR /
COPY --from=hugo /site/public /site
