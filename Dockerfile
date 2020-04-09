FROM registry.gitlab.com/jamietanna/jvt.me/hugo-base:0.68.3 AS hugo
COPY ./ /site
RUN hugo --destination=/public --verbose --minify

# Final, built image
FROM scratch
WORKDIR /
COPY --from=hugo /public /site
