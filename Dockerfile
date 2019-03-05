FROM debian:9

ENV HUGO_VERSION 0.54.0
ENV HUGO_SHA b09c0cbd7fd6ac432f94e9547d8a0e1714fcc7078cf8736c7cd7f35a3ceb9a17

# Install HUGO
RUN apt update \
  && apt install -y curl git \
  && rm -rf /var/lib/apt/lists/* \
  && curl -SL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb -o /tmp/hugo.deb \
  && echo "${HUGO_SHA}  /tmp/hugo.deb" | sha256sum -c \
  && dpkg -i /tmp/hugo.deb \
  && hugo version

WORKDIR /site

CMD ["hugo", "-d", "public", "--enableGitInfo", "--minify"]
