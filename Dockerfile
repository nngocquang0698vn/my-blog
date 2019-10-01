FROM klakegg/hugo:0.58.3-ext-alpine AS hugo
RUN apk --update add git tzdata && \
	cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
	echo 'Europe/London' > /etc/timezone
ENV HUGO_DESTINATION /public
WORKDIR /site
COPY ./ /site
RUN hugo --destination=/public --verbose --enableGitInfo

FROM scratch
WORKDIR /
COPY --from=hugo /public /site
